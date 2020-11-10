CHAPTERS = CountingCh.xml FilesCh.xml FirstProgsCh.xml FunctionsCh.xml IntroductionCh.xml LinkingCh.xml MemoryCh.xml MemoryIntCh.xml OptimizationCh.xml OtherLangCh.xml RobustCh.xml WhereNextCh.xml
APPENDICES = ASCIIAp.xml GUIAp.xml SyscallAp.xml
PROGS = alloc.s exit.s factorial.s Hello-World.c helloworld-lib.s helloworld-nolib.s maximum.s printf-example.s toupper2.s toupper3.s toupper.s
GRAPHICS = assembling-a-program.dia memorypages.svg memory.svg
INDEX = index.xml
BOOKNOINDEX = ProgrammingGroundUp.xml programming.dsl $(CHAPTERS) $(PROGS) $(GRAPHICS) $(APPENDICES)
FULLBOOK = $(BOOKNOINDEX)
JADE = openjade

all: ProgrammingGroundUp.pdf

ProgrammingGroundUp.ps: ProgrammingGroundUp.tex
	jadetex ProgrammingGroundUp.tex
	jadetex ProgrammingGroundUp.tex
	jadetex ProgrammingGroundUp.tex
	jadetex ProgrammingGroundUp.tex
	dvips ProgrammingGroundUp.dvi -o ProgrammingGroundUp.ps

ProgrammingGroundUp.pdf: ProgrammingGroundUp.tex
	pdfjadetex ProgrammingGroundUp.tex
	pdfjadetex ProgrammingGroundUp.tex
	pdfjadetex ProgrammingGroundUp.tex
	pdfjadetex ProgrammingGroundUp.tex

draft: ProgrammingGroundUp.tex
	$(JADE) -t tex -d programming.dsl#printdraft xml.dcl ProgrammingGroundUp.xml
	pdfjadetex ProgrammingGroundUp.tex

ProgrammingGroundUp.tex: $(FULLBOOK)
	$(JADE) -t tex -d programming.dsl#printdraft xml.dcl ProgrammingGroundUp.xml

index.xml: HTML.index 
	collateindex.pl -o index.xml HTML.index
	#./fixindex.pl

HTML.index: $(BOOKNOINDEX)
	collateindex.pl -N >index.xml
	$(JADE) -t sgml -V html-index -V nochunks -d /usr/share/sgml/docbook/dsssl-stylesheets/html/docbook.dsl xml.dcl ProgrammingGroundUp.xml >/dev/null
	rm -f *.htm *.html

index: index.xml

semiclean:
	rm -f ProgrammingGroundUp.log
	rm -f ProgrammingGroundUp.aux
	rm -f ProgrammingGroundUp.tex
	rm -f ProgrammingGroundUp.dvi
	rm -f ProgrammingGroundUp.ps
	rm -f ProgrammingGroundUp.pdf

clean: semiclean
	rm -f HTML.index
	rm -f index.xml

download:
	scp -C johnnyb@eskimo.com:/u/j/johnnyb/Projects/ProgrammingGroundUp/*.* .

upload:
	scp -C *.* Makefile johnnyb@eskimo.com:/u/j/johnnyb/Projects/ProgrammingGroundUp/

