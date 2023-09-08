%title: A brief introduction to using git
%author: heywoodlh

-> ## Using git for solo development <-

-> Some introductory git commands <-

---

-> ## Git background <-

Created by Linus Torvalds for Linux development:
- Replaced Bitkeeper, a proprietary tool once used to distribute Linux source code
- Bitkeeper revoked their free-of-charge status, prompting Linus to create a replacement

Used by nearly every entity that develops software. Some big names:
- Microsoft (who now owns GitHub)
- Apple
- Google
- Facebook
- Do I need to continue?

---

-> ## Git is _not_ GitHub <-

Git is a command line tool that can work with any `git` hosting service:
- Any SSH server
- GitHub: https://github.com
- GitLab: https://gitlab.com
- Bitbucket: https://bitbucket.org
- SourceHut: https://sr.ht
- Many other providers

---

-> ## Create a git repository on GitHub: <-

Assuming you've set up the `gh` GitHub CLI tool, you can use this command to create a new public git repository on GitHub:

```
gh repo create my-new-repo --public
```

Then use this command to clone the new, empty repo locally to your computer (assumes you've configured SSH):

```
USERNAME="my-username"

git clone git@github.com:$USERNAME/my-new-repo.git
```

---

-> ## Modify the repo, commit and push your changes <-

First, `cd` into `my-new-repo`:

```
cd my-new-repo
```

Now, let's use the `printf` command to create a new `README.md` file:


```
printf "This is a README!" > README.md
```

Check your `git` status -- it should show that we have a new, untracked file named `README.md`:

```
git status
```

Now, let's commit the changes and add the file to your remote repository (this assumes your current branch is named `main`):

```
git add README.md
git commit -m 'added example readme'
git push origin main
```

You should see the changes pushed to the GitHub repository.

---

-> ## Editing files <-

Now, use `vim`, `nano`, VSCode or some other text editor tool to edit `README.md` and change it however you want.

You should see that the file has been changed:

```
git status
```

Every time you make a change, it will not be tracked until you `add` the change to the upcoming commit:

```
git add README.md
```

The change has been staged, meaning that you want to track the change. Check your status again:

```
git status
```

Now, let's make another commit (essentially, create a snapshot of your staged changes):

```
git commit -m 'updated README.md'
```

And now push your changes to the remote repository on GitHub:

```
git push origin main
```

---

-> ## Editing pt. 2 <-

Let's make some changes and also create an unwanted file and push it to the remote repository:

```
printf 'a change I want to keep' >> README.md
git add README.md

printf 'something' > unwanted.txt
git add unwanted.txt

git commit -m 'some changes I made'
git push origin main
```

Now that file is committed to our git repository -- but let's remove it (not from history, just from the current file structure):

```
git rm unwanted.txt

git commit -m 'removed unwanted.txt'
git push origin main
```

---

-> ## Recap <-

Clone a remote repository:

```
git clone <github-uri>
```

i.e.

```
git clone git@github.com:heywoodlh/my-new-repo.git
```

After changing files, stage them with `git add`:

```
git add changed-file.txt
```

Once you've made sufficient changes, commit them (tip: `git commit -m` messages should explain what you're committing):

```
git commit -m 'some message explaining what I did'
```

Then push to your remote repository:

```
git push origin main
```

Use `git rm` to remove undesired files from the current repo file structure:

```
git rm unwanted-file.txt
git commit -m 'removed unwanted file'
git push origin main
```

---

-> ## Some git tips <-

Here are some tips I have on using `git`:
- Put everything you do into a `git` repository that people can see -- employers love it and it will force you to make higher quality code
- Don't commit secrets to `git`
- Always use expressive `git` commit messages
- Practice with `git` a lot
