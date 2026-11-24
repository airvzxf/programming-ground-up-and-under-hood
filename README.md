# Assembly from the Ground Up: x86 32-bit Edition

An updated Linux edition of [_Programming from the Ground Up_](https://savannah.nongnu.org/projects/pgubook) by Jonathan Bartlett, maintained by Israel Roldan (AirvZxf).

- This is the **x86 32-bit edition**. An x86-64 edition, for 64-bit programs, will be published in its own repository.
- Read online and download the PDF and ePUB: <https://asm32.rovisoft.net/>
- Downloads for every version: [GitHub releases](https://github.com/airvzxf/assembly-from-the-ground-up-x86-32/releases).

## Build

The book is a [Quarto](https://quarto.org/) book project in `src/`: one Markdown file (`.qmd`) per chapter and appendix, listed in `src/_quarto.yml`. Quarto (which includes Pandoc and [Typst](https://typst.app/)) builds the website (one page per chapter, with search), the PDF and the ePUB. The pinned version is in `scripts/install-deps.bash`.

```bash
podman build -t pgu-book .                 # or docker
podman run --rm -v "$PWD:/data:Z" pgu-book -c 'bash src/make.bash'
podman run --rm -v "$PWD:/data:Z" pgu-book -c 'bash src/resource/asm/make.bash && bash src/resource/asm/test.bash'
```

The output is in `release/latest/`: the PDF, the ePUB, `resource.zip` with the example programs, and `site/`, the website. To preview the website while you write, run `quarto preview` in `src/`.

The website is published by Cloudflare Pages, connected to this repository: every push to `main` builds it with `bash scripts/cloudflare-build.bash` (output directory `release/latest/site`), and every pull request gets a preview deployment.

## License

- **The book** (the `.qmd` files in `src/` and the editions built from them) is a Modified Version of _Programming from the Ground Up_, so it stays under the [GNU Free Documentation License, Version 1.1](LICENSE-GFDL-1.1.txt) or any later version, with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. The GFDL requires the modified book to use that same license.
- **The code of this repository** (build scripts, Pandoc filters and templates, and the example programs) is under the [GNU Affero General Public License v3.0](LICENSE). The original author also grants full rights to use the book's code examples for any purpose.

## About this project.

I try to learn the GNU Assembler (`as` or `gas`) and I didn't find many resources but this book is great.

This is a 60% of the WIP (work in progress) for the project `Programming from the ground up`.

Goals:

- [ ] Programming from the ground up.
  - [x] Convert the original _DocBook_ to a _Markdown_ then with [pandoc](https://pandoc.org/) convert it to _ePUB_, _MOBI_ and _PDF_.
  - [ ] Improve and update the sections where I am missing.
  - [ ] Try to fix the [bugs](https://savannah.nongnu.org/bugs/?group=pgubook) and [support tickets](https://savannah.nongnu.org/support/?group=pgubook), since 2004 is not updated this [book](https://savannah.nongnu.org/projects/pgubook).
- [ ] Programming under hood.
  - [ ] Convert the original _LaTeX_ to a _Markdown_ then with [pandoc](https://pandoc.org/) then convert it to _ePUB_, _MOBI_ and _PDF_.
- [ ] Final version.
  - [ ] Create a version for x64 architecture.
- [ ] Create my own book based in the experience that I gained in this project. It should will in a new GitHub repository.

You're able to find my documents about assembly in my GitHub repository [airvzxf/assembly](https://github.com/airvzxf/assembly) also I was working in some assembler scripts that I wrote based on the [exercises of this book](https://github.com/airvzxf/assembly/tree/master/linux/gas/programmingGroundUp). It contains a Linux shell script to make all the binaries straightforward.

### Motivations.
- I believe that Linux is the future, I dream with a world when everyone is using Linux in our laptops, desktop computers, and all the video game companies make perfect games for Linux.
- I was researching about GNU Assembler (“as” or “gas”) but unfortunately, there are not many resources, these resources talk about the most popular as “[NASM](https://nasm.us/)” and “[FASM](https://flatassembler.net/)”.
- Why NOT focus on “NASM” or “FASM”? I started with “NASM” then I saw a few years ago the active development stopped. I researched about “FASM” and looks like it's awesome but then I discovered some curious detail. These assemblers can compile in many architectures and it is powerful but trying to be very compatible they spend a lot of effort to create the most generic binary source possible ([1](#1)). At this moment I start to consider the possibility to use the pure Linux assembler because for me the idea to use a multi-architectural assembler is only marketing. I have been software developer over 14  years and I never created a multi-architecture system neither in my personal projects. Why am I living in a utopia? Wanted a tool to convert to other architectures, if I always create programs for Linux and very rarely for Windows. In these cases I usually use Python or Java. Note: This is my personal point of view, haters please hate more.
- Why use Assembler rather other languages programs? The benchmarks that I did demonstrate that Assembler is the most powerful even tan C which is the top language. [My benchmarks](https://github.com/airvzxf/assembly/tree/master/linux/benchmark/fibonacci/without_print) and the [C benchmarks](https://benchmarksgame-team.pages.debian.net/benchmarksgame/fastest/cpp.html).
- Why update this book? This book is one of the best that I found but it has many areas of opportunity. I read until the chapter 3 and I had three doubts in the final exercises but there are no answers. The book said that we saw this subject and I reviewed all the chapters and it didn't.
- Deep thanks to the men and companies who inspired me to be better and thanks to the Open Source: [Linus Torvalds](https://github.com/torvalds), [Richard Stallman](https://stallman.org/), [Linux](https://www.linux.org/), [GNU](https://www.gnu.org/), [GitHub](https://github.com/).

### First steps: Programming from the ground up.
- [x] Download the original source code.
- [x] Figured out how to compile the source code.
  - [x] It's not easy and needs to install some packages also I couldn't compile the book. Other reason is that the DSSSL is an old technology.
- [x] Make decisions if keeps this format or use other tools/format.
  - [x] Use `pandoc` ([official project](https://pandoc.org/)) to convert the original DocBook to Markdown format.
    - [x] Fix all the conversions failures.
      - [x] Footnotes needs to create a new numeration.
      - [x] Internal broken links for references.
      - [x] Styles and formats.
      - [x] Create a ToC (Table of contents).
    - [x] Export to the final version to ePUB.
    - [ ] Export to the final version to MOBI for Kindle.
- [x] Start with the [TO-DO's file](TODO.md).

## About the original books.

### Important notes.
- This book is under the “GNU Free Documentation License”. The modified version is named _Assembly from the Ground Up: x86 32-bit Edition_ because the license requires a title distinct from the original.

### Original source: Programming from the ground up.
- Title: Programming from the Ground Up
- Author: Jonathan Bartlett
- Editor: Dominick Bruno, Jr.
- Copyright: © 2003 by Jonathan Bartlett
- License: GNU Free Documentation License, Version 1.1 or any later version published
- License link: [https://www.gnu.org/licenses/licenses.html#FDL](https://www.gnu.org/licenses/licenses.html#FDL)
- Resource page: [https://savannah.nongnu.org/projects/pgubook](https://savannah.nongnu.org/projects/pgubook)
- Source code: [https://cvs.savannah.nongnu.org/viewvc/pgubook/pgubook/ProgrammingGroundUp/](https://cvs.savannah.nongnu.org/viewvc/pgubook/pgubook/ProgrammingGroundUp/)

### Original source: Programming under the hood.
- Title: Programming under the hood
- Author: Jonathan Bartlett
- Copyright: © 2017 Jonathan Bartlett
- License: GNU Free Documentation License
- License link: [https://www.gnu.org/copyleft/](https://www.gnu.org/copyleft/)
- Source code: [https://github.com/johnnyb/programming_under_the_hood](https://github.com/johnnyb/programming_under_the_hood)


## Footnotes:
- <span id="1">1</span>: [FASM: Design Principles, or Why FASM Is Different](https://board.flatassembler.net/topic.php?t=3197) sections “4) Resolving The Code” and “5) Complex Solutions With Simple Features”. In general this document provides an overview of the complexity behind trying to do an assembler multi-architecture.
