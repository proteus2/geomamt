FC = gfortran
FLAGS = -g -O

OBJ = sinv2d.o getdata.o outdata.o modelsetup.o \
      mcov.o setupop.o sens2d.o representer.o\
      fwd2d.o fwd1d.o search.o\
      utilfunct.o\
      LAPACK_R8.o LAPACK_C16.o BLAS1.o BLAS2_3.o 

rebocc : $(OBJ) 
	$(FC) $(FLAGS) $(OBJ) -o rebocc

sinv2d.o : sinv2d.f 
	$(FC) $(FLAGS) -c sinv2d.f

getdata.o : getdata.f 
	$(FC) $(FLAGS) -c getdata.f

outdata.o : outdata.f 
	$(FC) $(FLAGS) -c outdata.f

modelsetup.o : modelsetup.f 
	$(FC) $(FLAGS) -c modelsetup.f

mcov.o : mcov.f 
	$(FC) $(FLAGS) -c mcov.f

setupop.o : setupop.f 
	$(FC) $(FLAGS) -c setupop.f

sens2d.o : sens2d.f 
	$(FC) $(FLAGS) -c sens2d.f

representer.o : representer.f 
	$(FC) $(FLAGS) -c representer.f

search.o : search.f 
	$(FC) $(FLAGS) -c search.f

fwd2d.o : fwd2d.f 
	$(FC) $(FLAGS) -c fwd2d.f

fwd1d.o : fwd1d.f 
	$(FC) $(FLAGS) -c fwd1d.f

utilfunct.o : utilfunct.f 
	$(FC) $(FLAGS) -c utilfunct.f

BLAS1.o : BLAS1.f
	$(FC) $(FLAGS) -c BLAS1.f

BLAS2_3.o : BLAS2_3.f
	$(FC) $(FLAGS) -c BLAS2_3.f

LAPACK_R8.o : LAPACK_R8.f
	$(FC) $(FLAGS) -c LAPACK_R8.f

LAPACK_C16.o : LAPACK_C16.f
	$(FC) $(FLAGS) -c LAPACK_C16.f
