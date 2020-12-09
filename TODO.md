# TO-DO's


## Programming from the ground up


### Me

#### Technical

- [x] Generate my theme of GNU Assembler and apply to the fenced code blocks. [Pandoc: Syntax highlighting](https://pandoc.org/MANUAL.html#syntax-highlighting).
- [x] Fix the missing include files with the source code.
- [x] Reduce the text columns for every assembly source file which is broken in the ePUB version, the limit is 55 characters.
- [x] Upgrade all the code blocks of Bash. Assemble with 32-bit and link the i386 emulation.
- [ ] Rename the assembly source files with the prefix chapters and appendixes `001-`, `012`, `AA-` and `AF-`.
- [ ] Execute and fix all the assembly source files.
- [ ] Create bash script to compile and link all the assembler files.
- [ ] Add line numeration to the included source files and the small pieces of code.
- [ ] Removed the folder repository "airvzxf/assembly/linux/gas/programmingGroundUp" and add in the README file the reference to this project.
- [ ] Fix the cover and pages for PDF and ePUB also fixed the error in the HTML5 version.
- [ ] Add my own page in the book talking about the project and refer the GitHub Repository link.
- [ ] Create a ToC (Table of contents).
- [ ] Complete all my peronsal To-Do's which are hardcoded in the book.
- [ ] Create releases as `./releases/v2020.12.01/ProgrammingGroundUp.epub`. Create commands in the `./make` script to replace the version (`text: x86 v2020.12`) inside of the `001-ProgrammingGroundUp.txt` file.
- [ ] Automate the release process with GitHub Actions.

#### Knowledge

- [ ] Add appendix for the solutions in every chapter.
  - [ ] Chapter 2. Data Accessing Methods
  - [ ] Chapter 3. Your First Programs
  - [ ] Chapter 4. All About Functions Dealing with Complexity
  - [ ] Chapter 5. Dealing with Files
  - [ ] Chapter 6. Reading and Writing Simple Records
  - [ ] Chapter 7. Developing Robust Programs
  - [ ] Chapter 8. Sharing Functions with Code Libraries
  - [ ] Chapter 9. Intermediate Memory Topics How a Computer Views Memory
  - [ ] Chapter 10. Counting Like a Computer Counting
  - [ ] Chapter 11. High-Level Languages
  - [ ] Chapter 12. Optimization
  - [ ] Chapter 13. Moving On from Here
- [ ] Check spelling for all the book with [LanguageTool](https://languagetool.org/)


### Author notes.

- [ ] General.
  - [ ] Dominique suggests I have an appendix of registers. Maybe in the Instructions appendix?
  - [ ] Need to find places that need more filling out.  Reviews, definitely.
  - [ ] Go back through and make sure that registers and memory are both fully described and fully distinguished.
  - [ ] Instructions needs some more beef from reference books.
  - [ ] Appendices.
    - [ ] A full description of the calling sequence for UNIX.
    - [ ] A complete examination of the fetch-execute cycle.
    - [ ] A complete listing of registers and flags.

- [ ] Chapters.
  - [ ] Chapter 2. Data Accessing Methods.
    - [ ] This would be a good section for diagrams.
  - [ ] Chapter 3. Your First Programs.
    - [ ] Dominique suggests an extended example of this: Anything strange your program does and why it does it.
  - [ ] Chapter 4. All About Functions Dealing with Complexity
    - [ ] Dominique says "This part can be confusing until one gets to the sample illustration code and then it makes sense."
  - [ ] Chapter 5. Dealing with Files
    - [ ] Do I need to introduce flowcharting or reference it here?
    - [ ] Needs to be re-sectionalized and reviewed
    - [ ] Probably need to start with a "hello world" program
  - [ ] Chapter 6. Reading and Writing Simple Records
    - [ ] Need to add info on how to use a hexdump to read the values
  - [ ] Chapter 10. Counting Like a Computer Counting
    - [ ] These need to be converted to tables.
    - [ ] Need floating point reference. For more information on using floating point numbers in assembly language, `see:`.
  - [ ] Chapter 12. Optimization
    - [ ] Dominique suggestion - have an appendix with multiple versions of optimized code


### My notes.

- [ ] Chapters.
  - [x] Chapter 3. Your First Programs.
    - [x] Convert the "Layout of the 32-bit registers" image to a text format.
    - [x] Refer the GDB debug in the review sections for chapter 3.
  - [ ] Chapter 4.All About Functions Dealing with Complexity
    - [ ] Create a better example about the Stack software and hardware.
  - [ ] Chapter 5. Dealing with Files
    - [ ] Check if the values of the stack (%esp), 4(%esp), 8(%esp) are correct.
  - [x] Chapter 8. Sharing Functions with Code Libraries
    - [x] Added output from the above command.
    - [x] Test this ldd section, what is the real result?
  - [x] Chapter 9. Intermediate Memory Topics How a Computer Views Memory
    - [x] Convert the image into the text table.
  - [ ] Appendix F. Using the GDB Debugger.
    - [x] Add the plus signal to the GStabs: `as --gstabs` vs `as --gstabs+`.
    - [ ] Looks like this is not a good example for the command nexti vs stepi.


### Pending in the official website.

- [ ] Apply the bugs reported in the official resource page: [https://savannah.nongnu.org/bugs/?group=pgubook](https://savannah.nongnu.org/bugs/?group=pgubook).
- [ ] Apply the support requests in the official resource page: [https://savannah.nongnu.org/support/?group=pgubook](https://savannah.nongnu.org/support/?group=pgubook).
