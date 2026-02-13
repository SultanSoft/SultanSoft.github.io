# Project Requirements

## Project Details
- Project Name = 'ezgpg'
- Project Language = C
- Project Goal = Create a linux binary that wraps around gpg and systemd-ask-password to encrypt and decrypt files symmetrically.

## Project Requirements
1. Use the C language for this project.
2. Create a linux binary with -e or --encrypt and -d or --decrypt and the file name as inputs.
  - Example: 'ezgpg -e file.txt' or 'ezgpg --encrypt file.txt'
  - Example: 'ezgpg -d file.txt.gpg' or 'ezgpg --decrypt file.txt.gpg'
3. Use systemd-ask-password to prompt the user for a password and confirm the password.  Passwords must match to proceed.
4. Confirming the password is not necessary for decryption.  Only prompt once.
5. Passwords require a 12 character minimum of any type. This should be noted in the user prompt.  The 12 character requirement and prompt is not needed for decryption.
6. Pass the input password from systemd-ask-password to gpg to symmetrically encrypt or decrypt the input file.
7. Before decryption, if the output filename already exists, prompt the user for a new file name until there is no conflict.
8. When encrpyting, the ouput filename should end with .gpg.  When decrypting, the .gpg should be removed.
9. Include usage instructions for the binary when the user calls 'ezgpg --help'.
10. Increment the binary version number with each code change (not testing). Show the version number when the user enters 'ezgpg --version. Version numbers start at 0.0.1.  Only update the far right number.  Make the version number in the code obvious so I can change it manually if needed.
