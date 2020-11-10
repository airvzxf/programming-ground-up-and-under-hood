# Programming Ground Up — x86 v2020.11 Updated by AirvZxf and the community.

## About this project.

This is a 1% of the WIP (work in progress) project trying to fix, improve and update the [original book](https://savannah.nongnu.org/projects/pgubook) which looks like it is not updated since 2004.

You're able to find my documents about assembly in my GitHub repository [airvzxf/assembly](https://github.com/airvzxf/assembly) also I was working in some assembler scripts that I wrote based on the [exercises of this book](https://github.com/airvzxf/assembly/tree/master/linux/gas/programmingGroundUp), it contains a Linux shell script to make all the binaries very easy.

### Motivations.
- I believe that Linux is the future, I dream with a world when everyone is using Linux in our laptops, desktop computers, the video games are performed to Linux rather than Windows.
- I was researching about GNU Assembler (“as” or “gas”) but unfortunately there are not a lot of resources, all of these resources talk about the most popular as “[NASM](https://nasm.us/)” and “[FASM](https://flatassembler.net/)”.
- Why I'm NOT focused “NASM” or “FASM”? I started with “NASM” then I saw the active development was stopped a few years ago then I researched about “FASM” and looks like it's awesome but then I discovered some curious detail, these assemblers are able to compile in a lot of architectures and I searched in the “FASM” forums that it was powerful but trying to be very compatible they spend a lot of effort to create the most generic binary source possible ([1](#1)). At this moment I start to consider the possibility to use the pure Linux assembler because for me the idea to use a multi-architectural assembler is only marketing, I have been software developer over 14  years and I never created a multi-architecture system neither in my personal projects then why I'm living in a utopia trying to want a tool to convert to other architectures if I always create programs for Linux and very rarely for Windows. In these cases I usually use Python or Java. Note: This is my personal point of view, haters please hate more.
- Why use Assembler rather other languages programs? The benchmarks that I did demonstrate that Assembler is the most powerful even tan C which is the top language. [My benchmarks](https://github.com/airvzxf/assembly/tree/master/linux/benchmark/fibonacci/without_print) and the [C benchmarks](https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/cpp.html).
- Why I'm updating this book? I read until the chapter 3 and I had three doubts in the final exercises but there are no answers also the book said that we saw this subject and I reviewed all the chapters and it didn't, if the assembler language is difficult then add that the GNU assembler multiply this difficulty then try to imagine if the book is missing some little details. I really mean this book is one of the best but it has a lot of areas of opportunity.
- Deep thanks to the men and companies who inspired me to be better and thanks to Linux, GNU and the Open Source: [Linus Torvalds](https://github.com/torvalds), [Richard Stallman](https://stallman.org/), [Linux](https://www.linux.org/), [GNU](https://www.gnu.org/), [GitHub](https://github.com/).

### First steps.
- Download the original source code.
- Figured out how to compile the source code.
- Make decisions if keeps this format or use other tool/format.
- Start with the TO-DO's.

### TO-DO's.
- Apply the bugs reported in the official resource page: [https://savannah.nongnu.org/bugs/?group=pgubook](https://savannah.nongnu.org/bugs/?group=pgubook)
- Apply the support requests in the official resource page: [https://savannah.nongnu.org/support/?group=pgubook](https://savannah.nongnu.org/support/?group=pgubook)
- Add the solution for the last review sections.
  - Chapter 3.
- Update the GDB debug appendix.
  - Example: `as --gstabs` vs `as --gstabs+`
- Refer the GDB debug in the review sections.

## About the original book: Programming from the Ground Up.

### Important notes.
- This book is under the License: “GNU Free Documentation License, Version 1.1or any later version published” I added the license “GNU General Public License v3.0” in this repository as a reference but keep as a high priority and the only valid license the original license.

### Original source.
- Title: Programming from the Ground Up
- Author: Jonathan Bartlett
- Editor: Dominick Bruno, Jr.
- Copyright: © 2003 by Jonathan Bartlett
- License: GNU Free Documentation License, Version 1.1 or any later version published
- License link: [https://www.gnu.org/licenses/licenses.html#FDL](https://www.gnu.org/licenses/licenses.html#FDL)
- Resource page: [https://savannah.nongnu.org/projects/pgubook](https://savannah.nongnu.org/projects/pgubook)
- Source code: [https://cvs.savannah.nongnu.org/viewvc/pgubook/pgubook/ProgrammingGroundUp/](https://cvs.savannah.nongnu.org/viewvc/pgubook/pgubook/ProgrammingGroundUp/)


## Footnotes:
- <span id="1">1</span>: [FASM: Design Principles, or Why fasm Is Different](https://board.flatassembler.net/topic.php?t=3197) sections “4) Resolving The Code” and “5) Complex Solutions With Simple Features”. In general this document provides an overview of the complexity behind trying to do an assembler multi-architecture.
