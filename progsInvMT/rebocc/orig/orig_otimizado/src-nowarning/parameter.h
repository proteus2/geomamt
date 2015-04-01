
C     NMODMX  : MAX NO. OF MODE. (3 IS MAXIMUM)

      INTEGER NMODMX
      PARAMETER (NMODMX =  3)

C               DATA DIMENSION PARAMETERS   
C
C     NPER*MX : MAX NO. OF PERIOD  IN MODE NUMBER *.
C     NSTA*MX : MAX NO. OF STATION IN MODE NUMBER *.
C     NRES*MX : MAX NO. OF RESPOND IN MODE NUMBER *. 
C     NN0MX  : MAX NO. OF DATA PARAMETER = NPERMX*NSTEMX*NRESMX*NMODMX
C


C     FIRST MODE
      INTEGER NPER1MX,NSTA1MX,NRES1MX,NN1MX
      PARAMETER (NRES1MX =  2)
      PARAMETER (NPER1MX = 91,NSTA1MX = 75)
      PARAMETER (NN1MX   = NPER1MX*NSTA1MX*NRES1MX)

C     SECOND MODE
      INTEGER NPER2MX,NSTA2MX,NRES2MX,NN2MX
      PARAMETER (NRES2MX =  2)
      PARAMETER (NPER2MX = 91,NSTA2MX = 75)
      PARAMETER (NN2MX   = NPER2MX*NSTA2MX*NRES2MX)

C     THRID MODE
      INTEGER NPER3MX,NSTA3MX,NRES3MX,NN3MX
      PARAMETER (NRES3MX =  2)
      PARAMETER (NPER3MX = 91,NSTA3MX = 75)
      PARAMETER (NN3MX   = NPER3MX*NSTA3MX*NRES3MX)

      INTEGER NPERMX,NSTAMX,NRESMX,NPER0MX,NSTA0MX,NRES0MX
      PARAMETER (NRES0MX =  MAX(NRES1MX,NRES2MX))
      PARAMETER (NPER0MX =  MAX(NPER1MX,NPER2MX))
      PARAMETER (NSTA0MX =  MAX(NSTA1MX,NSTA2MX))
      PARAMETER (NRESMX  =  MAX(NRES3MX,NRES0MX))
      PARAMETER (NPERMX  =  MAX(NPER3MX,NPER0MX))
      PARAMETER (NSTAMX  =  MAX(NSTA3MX,NSTA0MX))
      INTEGER NN0MX
      PARAMETER (NN0MX  = NN1MX + NN2MX + NN3MX)

C
C             REPRESENTER DIMENSION PARAMETERS
C
C     By default, these parameters do not need to be adjusted if using 
C     3rd-stripe pattern and up (4th,5th, ...) as a reduced basis function.
C     Only adjusting them when having memory problems.

      INTEGER LPER1MX,LSTA1MX,LL1MX
      PARAMETER (LPER1MX = NPER1MX/3,LSTA1MX=NSTA1MX)
      PARAMETER (LL1MX=NRES1MX*LPER1MX*LSTA1MX)

      INTEGER LPER2MX,LSTA2MX,LL2MX
      PARAMETER (LPER2MX = NPER2MX/3,LSTA2MX=NSTA2MX)
      PARAMETER (LL2MX=NRES2MX*LPER2MX*LSTA2MX)

      INTEGER LPER3MX,LSTA3MX,LL3MX
      PARAMETER (LPER3MX = NPER3MX/3,LSTA3MX=NSTA3MX)
      PARAMETER (LL3MX=NRES3MX*LPER3MX*LSTA3MX)
    
      INTEGER LL0MX,LLHMX
      PARAMETER (LL0MX  = LL1MX+LL2MX+LL3MX)
      PARAMETER (LLHMX  = (LL0MX+1)*LL0MX/2)

C
C             MODEL DIMENSION PARAMETERS 
C
C     NZ0MX : MAX NO. OF Z-BLOCK  <= VERTICAL
C     NY0MX : MAX NO. OF Y-BLOCK  <= HORIZONTAL
C     NZ1MX : MAX NO. OF NODE IN Z-DIR = NZ0MX+1
C     NY1MX : MAX NO. OF NODE IN Y-DIR = NY0MX+1
C     MM0MX : MAX NO. OF BLOCK  = NY0MX*NZ0MX
C     MMIMX : MAX NO. OF INTERIOR NODE = (NY0MX-1)*(NZ0MX-1) 
C     MMBMX : MAX NO. OF BOUNDARY NODE = 2*NY0MX + 2*NZ0MX
C

      INTEGER NY0MX,NZ0MX,NY1MX,NZ1MX,NZ2MX
      PARAMETER (NY0MX =300,    NZ0MX = 100)
      PARAMETER (NY1MX =NY0MX+1,NZ1MX = NZ0MX+1,NZ2MX = NZ0MX+2)

      INTEGER MM0MX,MMIMX,MMBMX,NZ3MX
      PARAMETER (MM0MX = NY0MX*NZ0MX)
      PARAMETER (MMIMX = (NY0MX-1)*(NZ0MX-1))
      PARAMETER (MMBMX = 2*NY0MX+2*NZ0MX)
      PARAMETER (NZ3MX = 3*NZ1MX+1)


C
C                    OTHER PARAMETERS
C

      INTEGER ITERMX
      PARAMETER (ITERMX = 100)
