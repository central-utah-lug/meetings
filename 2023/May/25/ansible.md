# Getting Started with Ansible

This tutorial will walk you through some basic Ansible principles. All resources used in this tutorial can be found here:

https://github.com/central-utah-lug/meetings/tree/main/2023/May/25

By the end of the tutorial, you will use Ansible to deploy a server on DigitalOcean, do some basic maintenance on the server, and destroy the server.

## Requirements

A MacOS or Linux machine that you can install Ansible on. Alternatively, if you want to use a preconfigured container environment, you can use the following Docker command to run a Docker container built for this demo:

```
docker run -it --rm docker.io/heywoodlh/ansible-demo
```

In the Docker container, all of the playbooks in this task are located in the `/ansible-demo/playbooks` directory. Additionally, `ansible`, `nano` and `vim` are available in the continer.

A DigitalOcean account:
* Create an API token with Read and Write permission to use for this tutorial (save it somewhere like a password manager): https://cloud.digitalocean.com/account/api/tokens

## Install Ansible with Pip

To install the latest version of Ansible, using Python's `pip` tool is easiest. Refer to your OS' documentation on installing Python 3 and `pip`.

Once `pip` is installed on your machine, you can use the following command to install Ansible globally:

```
sudo pip install ansible
```

On Linux/MacOS, use the following command to ensure `ansible` is installed and available for your machine to use:

```
which ansible
```

## Deploy a server with DigitalOcean's Ansible module

First, let's create a new directory and move into it for all of our commands:

```
mkdir ansible-demo
cd ansible-demo
```

Install the Ansible DigitalOcean collection, using `ansible-galaxy`:

```
ansible-galaxy collection install community.digitalocean
```

Before we can run any Ansible things against DigitalOcean's API, we need to set an API token environment variable for Ansible to use:

For MacOS/Linux:

```
export DO_API_TOKEN="contents-of-api-token"
```

### Deploy the server

Now, create a file at `playbooks/create-server.yml` with the following content:

```
---
- hosts: localhost
  tasks:

  - name: gather information about digitalocean ssh keys
    community.digitalocean.digital_ocean_sshkey_info:
    register: ssh_keys

  - name: set sshkey_pub_id when ansible-demo key exists
    set_fact:
      sshkey_pub_id: "{{ ssh_keys.data | selectattr('name', 'equalto', 'ansible-demo') | map(attribute='id') | first }}"
    ignore_errors: true

  - name: create ssh key without passphrase at /tmp/ansible-demo-id_rsa
    ansible.builtin.command: ssh-keygen -b 2048 -t rsa -f /tmp/ansible-demo-id_rsa -N ""
    when: sshkey_pub_id is not defined

  - name: read contents of /tmp/ansible-demo-id_rsa.pub
    ansible.builtin.command: cat /tmp/ansible-demo-id_rsa.pub
    register: sshkey_pub
    when: sshkey_pub_id is not defined

  - name: upload ssh key to digitalocean
    community.digitalocean.digital_ocean_sshkey:
      name: "ansible-demo"
      ssh_pub_key: "{{ sshkey_pub.stdout }}"
      state: present
    register: result
    when: sshkey_pub_id is not defined

  - name: set sshkey_pub_id when ansible-demo key exists
    set_fact:
      sshkey_pub_id: "{{ result.data.ssh_key.id }}"
    when: sshkey_pub_id is not defined

  - name: create a new digitalocean server
    community.digitalocean.digital_ocean_droplet:
      state: present
      name: ansible-demo
      size: s-1vcpu-1gb
      region: sfo3
      image: ubuntu-22-04-x64
      wait_timeout: 500
      ssh_keys: 
      - "{{ sshkey_pub_id }}" 
      unique_name: true
    register: my_droplet
```

Now, run the playbook:

```
ansible-playbook playbooks/create-server.yml
```

## Add the server to inventory

Ansible uses something called "inventory" to track remote servers that you want to run tasks against. Now that the server is created, let's create an inventory file manually (you can use Ansible to programmatically do this, but for the sake of learning, let's do it manually).

Login to DigitalOcean and grab the IP address of the newly created server from DO's console. Then, create a simple inventory file named `hosts` with the following content (replacing `<server-ip>` with your IP address):

```
ansible-demo ansible_host=<server-ip> ansible_user=root ansible_ssh_private_key_file=/tmp/ansible-demo-id_rsa
```

Now, we can run Ansible playbooks against the `ansible-demo` server!

Test connectivity to the `ansible-demo` server defined in the inventory with Ansible's ping module:

```
ansible ansible-demo -i hosts -m ping
```

## Some simple playbook examples to run against your host

We will now create some example playbooks to run against the new `ansible-demo` server in our Ansible inventory.

### Create a user

A common system administration task on remote servers is to manage users. So let's create a new user named `tempuser` with Ansible.

Create a file at `playbooks/adduser-tempuser.yml` with the following content:

```
---
- hosts: ansible-demo
  tasks:
  - name: create tempuser 
    ansible.builtin.user:
      name: tempuser
      uid: 1050
      shell: /bin/bash
  - name: create /home/tempuser/.ssh
    ansible.builtin.file:
      state: directory
      path: /home/tempuser/.ssh
      owner: tempuser
      mode: 0700
  - name: use previously generated ssh key as ~/.ssh/authorized_keys file for tempuser
    ansible.builtin.copy:
      src: /tmp/ansible-demo-id_rsa.pub
      dest: /home/tempuser/.ssh/authorized_keys
      owner: tempuser
      mode: 0600
```

Now, let's run the playbook, using the newly created `hosts` file as inventory:

```
ansible-playbook -i hosts playbooks/adduser-tempuser.yml
```

To ensure that this worked, let's use Ansible's `ping` module, but let's supply a different user this time.

First, let's supply an invalid user so we can see how it looks when this fails:

```
ansible ansible-demo -e "ansible_user=invalid-user" -i hosts -m ping
```

Now, let's try with the new `tempuser` user that we created earlier:

```
ansible ansible-demo -e "ansible_user=tempuser" -i hosts -m ping
```

### Install some packages

Another common systems administration task is to install packages. So, let's use Ansible to ensure the latest version of a couple of packages is installed for anyone on the `ansible-demo` system to use.

Before we install the packages, run this command to see if the packages currently exist on the system (replace `server-ip` with the public IP address of your server):

```
ansible ansible-demo -i hosts -m ansible.builtin.command -a "dpkg -l" | grep -E 'emacs|neofetch|python3-pip'
```

The command should return nothing, meaning that none of the packages we are about to install are currently installed on the `ansible-demo` system.

Create `playbooks/install-packages.yml` with the following content:

```
---
- hosts: ansible-demo
  tasks:
  - name: install latest version of various packages with apt
    ansible.builtin.apt:
      update_cache: yes
      pkg:
      - emacs
      - neofetch
      - python3-pip
```

To be sure that the packages were actually installed, let's run a command on the server to verify each of those packages exist:

```
ansible ansible-demo -i hosts -m ansible.builtin.command -a "dpkg -l" | grep -E 'emacs|neofetch|python3-pip'
```

## Destroy the server:

Create `destroy-server.yml` with the following content to remove the SSH key and server created in `create-server.yml`:

```
---
- hosts: localhost
  tasks:

  - name: gather information about digitalOcean ssh keys
    community.digitalocean.digital_ocean_sshkey_info:
    register: ssh_keys

  - name: set sshkey_pub_id when ansible-demo key exists
    set_fact:
      sshkey_pub_id: "{{ ssh_keys.data | selectattr('name', 'equalto', 'ansible-demo') | map(attribute='id') | first }}"
    ignore_errors: true

  - name: remove ssh key from digitalocean
    community.digitalocean.digital_ocean_sshkey:
      name: "ansible-demo"
      id: "{{ sshkey_pub_id }}"
      state: absent
    when: sshkey_pub_id is defined

  - name: destroy ansible-demo digitalocean server
    community.digitalocean.digital_ocean_droplet:
      state: absent
      name: ansible-demo
      wait_timeout: 500
      unique_name: true
```
