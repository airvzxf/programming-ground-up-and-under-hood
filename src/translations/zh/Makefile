CHAPTERS = CountingCh.xml FilesCh.xml FirstProgsCh.xml FunctionsCh.xml IntroductionCh.xml LinkingCh.xml MemoryCh.xml MemoryIntCh.xml OptimizationCh.xml OtherLangCh.xml RobustCh.xml WhereNextCh.xml RecordsCh.xml
APPENDICES = ASCIIAp.xml GUIAp.xml SyscallAp.xml InstructionsAp.xml CTranslationAp.xml GDBAp.xml HistoryAp.xml FDLAp.xml DedicationAp.xml FDL-zh-Ap.xml
PROGS = alloc.s exit.s factorial.s Hello-World.c helloworld-lib.s helloworld-nolib.s maximum.s printf-example.s toupper2.s toupper3.s toupper.s
GRAPHICS = assembling-a-program.dia memorypages.svg memory.svg bigendian.png cip.png isbn.png littleendian.png mailbox.png memorylayout.png PGUFrontCover.png registerdescription.png
INDEX = index.xml
BOOKNOINDEX = ProgrammingGroundUp.xml programming.dsl $(CHAPTERS) $(PROGS) $(GRAPHICS) $(APPENDICES)
FULLBOOK = $(BOOKNOINDEX)
JADE = openjade

all: ProgrammingGroundUp.pdf

#ProgrammingGroundUp.ps: ProgrammingGroundUp.tex
#	jadetex ProgrammingGroundUp.tex
#	jadetex ProgrammingGroundUp.tex
#	jadetex ProgrammingGroundUp.tex
#	jadetex ProgrammingGroundUp.tex
#	dvips ProgrammingGroundUp.dvi -o ProgrammingGroundUp.ps

ProgrammingGroundUp.pdf: ProgrammingGroundUp.tex
	./gbkjdtx ProgrammingGroundUp.tex

ProgrammingGroundUp.tex: $(FULLBOOK) index.xml 
	env SP_ENCODING=UTF-8 $(JADE) -t tex -d programming.dsl#printdraft xml.dcl ProgrammingGroundUp.xml

index.xml: HTML.index 
	collateindex.pl -o index.xml HTML.index
	#./fixindex.pl

HTML.index: $(BOOKNOINDEX)
	collateindex.pl -N >index.xml
	env SP_ENCODING=UTF-8 $(JADE) -t sgml -V html-index -V nochunks -d /usr/share/sgml/docbook/dsssl-stylesheets/html/docbook.dsl xml.dcl ProgrammingGroundUp.xml >/dev/null
	rm -f *.htm *.html

index: index.xml

semiclean:
	rm -f ProgrammingGroundUp.log
	rm -f ProgrammingGroundUp.out
	rm -f ProgrammingGroundUp.aux
	rm -f ProgrammingGroundUp.tex
	rm -f ProgrammingGroundUp.dvi
	rm -f ProgrammingGroundUp.ps
	rm -f ProgrammingGroundUp.pdf
	rm -f ProgrammingGroundUp.cjk

clean: semiclean
	rm -f HTML.index
	rm -f index.xml

download:
	scp -C johnnyb@eskimo.com:/u/j/johnnyb/Projects/ProgrammingGroundUp/*.* .

upload:
	scp -C *.* Makefile johnnyb@eskimo.com:/u/j/johnnyb/Projects/ProgrammingGroundUp/

%.xml: po/%.po
	po4a-translate -f docbook -k 0 -m ../../$@ -p $< -l $@ -M UTF-8
