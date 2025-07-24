To upload large files (more than 100MB)
1. run command 'git lfs install'
2. Wait for these notification in cmd:
    Updated Git hooks.
    Git LFS initialized.
3. then run comman 'git lfs track "*.pdf"'
4. wait for this prompt:
    Tracking "*.pdf"
5. run command 'git lfs push --all origin main'
6. run command 'git add .'
7. run command 'git commit -m "Push .pdf file that more than 100MB"'
8. run command 'git add origin main'