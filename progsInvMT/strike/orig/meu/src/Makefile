BINDIR =$(HOME)/bin/

OBJS = calc_error.o     jcopyinfo.o      objfun.o \
       chiprob.o        date.o           jkvar.o          pinput.o \
       convz2p.o        estim_imp.o      mat_multiply.o \
       convz2r.o        extreme.o        \
       jcopycomm.o       func.o          num_rec.o        svarld.o \
       shiftup.o        trunc.o          trig_fns.o      \
       jformatfin.o     ediformatfin.o   jzdatin.o        edizdatin.o \
       edispecread.o    ediresread.o     mtcomp.o      \
       edicopycomm.o    edicopyinfo.o    revers.o      crevers.o \
       ediazimuth.o


FFLAGS = -C
#FFLAGS = -dalign -f -C

.f.o:; gfortran $(FFLAGS) -c $<

strike1: strike1.o $(OBJS)
	gfortran $(FFLAGS) -o strike1 strike1.o $(OBJS)
	mv strike1  $(BINDIR)

strike1.o: strike.f
	mv size.inc size.inc.save
	cp SIZE_1x100.inc size.inc
	gfortran -o strike1.o $(FFLAGS) -c strike.f
	mv size.inc.save size.inc

strike.o: strike.f size.inc version.inc
	gfortran $(FFLAGS) -c strike.f

ediformatfin.o: ediformatfin.f size.inc
	gfortran $(FFLAGS) -c ediformatfin.f

ediresread.o: ediresread.f size.inc
	gfortran $(FFLAGS) -c ediresread.f

edispecread.o: edispecread.f size.inc
	gfortran $(FFLAGS) -c edispecread.f

edizdatin.o: edizdatin.f size.inc
	gfortran $(FFLAGS) -c edizdatin.f

jformatfin.o: jformatfin.f size.inc
	gfortran $(FFLAGS) -c jformatfin.f

objfun.o: objfun.f size.inc
	gfortran $(FFLAGS) -c objfun.f

strike: strike.o $(OBJS)
	gfortran $(FFLAGS) -o strike strike.o $(OBJS) -L/usr/local/lib -lnag

dcmp2j.o: dcmp2j.f size.inc
	gfortran $(FFLAGS) -c dcmp2j.f

dcmp2j: dcmp2j.o pinput.o shiftup.o trunc.o
	gfortran $(FFLAGS) -o dcmp2j dcmp2j.o pinput.o shiftup.o trunc.o

install: strike
	mv strike $(BINDIR)

test: strike
	mv strike $(BINDIR)/test

dist:
	rm *.zip
	zip strike.zip *.f *.inc Makefile strike_example* e04* *.pdf strike.txt
	zip -d strike.zip nag_16a.f
