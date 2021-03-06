      SUBROUTINE D01EAF(NDIM,A,B,MINCLS,MAXCLS,NFUN,FUNSUB,ABSREQ,
     *                  RELREQ,LENWRK,WORK,FINEST,ABSEST,IFAIL)
C     MARK 12 RELEASE. NAG COPYRIGHT 1986.
C
C     ADAPTIVE MULTIDIMENSIONAL INTEGRATION SUBROUTINE
C
C      AUTHOR - ALAN GENZ, COMPUTER SCIENCE DEPARTMENT,
C               WASHINGTON STATE UNIVERSITY,
C               PULLMAN, WASHINGTON  99164
C
C     THIS SUBROUTINE COMPUTES AN APPROXIMATION TO THE INTEGRAL
C
C      B(1) B(2)     B(NDIM)
C     I    I    ... I       (F ,F ,...,F    ) DX(NDIM)...DX(2)DX(1),
C      A(1) A(2)     A(NDIM)  1  2      NFUN
C
C       WHERE F = F (X ,X ,...,X    ), I = 1,2,...,NFUN.
C              I   I  1  2      NDIM
C
C     *********  PARAMETERS FOR D01EAF  *******************************
C     INPUT PARAMETERS
C     NDIM    NUMBER OF VARIABLES
C     A       REAL ARRAY OF LOWER LIMITS, WITH DIMENSION(NDIM)
C     B       REAL ARRAY OF UPPER LIMITS, WITH DIMENSION(NDIM)
C     MINCLS  MINIMUM NUMBER OF FUNSUB CALLS TO BE ALLOWED,
C             MINCLS MUST NOT EXCEED MAXCLS.  IF MINCLS.LT.0 THEN THE
C             ROUTINE ASSUMES A PREVIOUS CALL HAS BEEN MADE WITH THE
C             SAME INTEGRANDS AND CONTINUES THAT CALCULATION.
C     MAXCLS  MAXIMUM NUMBER OF FUNSUB CALLS TO BE ALLOWED,
C             WHICH MUST BE AT LEAST IRCLS, WHERE
C             IRCLS =  2**NDIM+2*NDIM**2+2*NDIM+1, IF NDIM .LT. 11 OR
C             IRCLS = 1+NDIM*(12+(NDIM-1)*(6+(NDIM-2)*4))/3, OTHERWISE.
C     NFUN    NUMBER OF INTEGRANDS
C     FUNSUB  EXTERNALLY DECLARED USER DEFINED INTEGRAND SUBROUTINE
C             IT MUST HAVE PARAMETERS (NDIM,Z,NFUN,F), WHERE Z IS A REAL
C             ARRAY OF DIMENSION(NDIM) AND F IS A REAL ARRAY OF
C             DIMENSION (NFUN). F(I) MUST GIVE THE VALUE OF INTEGRAND
C             I AT Z.
C     ABSREQ  REQUIRED ABSOLUTE ACCURACY
C     RELREQ  REQUIRED RELATIVE ACCURACY
C     LENWRK  LENGTH OF ARRAY WORK OF WORKING STORAGE, THE ROUTINE
C             NEEDS LENWRK AT LEAST AS LARGE AS 8*NDIM + 11*NFUN + 3.
C             FOR MAXIMUM EFFICIENCY LENWRK SHOULD BE APPROXIMATELY
C             6*NDIM+9*NFUN+(NDIM+NFUN+2)*(1+MAXCLS/IRCLS) IF
C             MAXCLS FUNCTION CALLS ARE USED. IF LENWRK IS SIGNIFICANTLY
C             LESS THAN THIS D01EAF WILL WORK LESS EFFICIENTLY.
C
C     OUTPUT PARAMETERS
C     MINCLS  ACTUAL NUMBER OF FUNSUB CALLS USED BY D01EAF
C     WORK    REAL ARRAY OF WORKING STORAGE OF DIMENSION (LENWRK).
C     FINEST  REAL ARRAY OF DIMENSION(NFUN) OF ESTIMATED VALUES OF
C             INTEGRALS.
C     ABSEST  REAL ARRAY DIMENSION(NFUN) ESTIMATED ABSOLUTE ACCURACIES.
C             ABSEST(I) GIVES THE ESTIMATED ACCURACY FOR FINEST(I).
C     IFAIL   FAILURE INDICATOR
C             IFAIL=0 FOR NORMAL EXIT, WHEN MAX(ABSEST) .LE. ABSREQ OR
C                     MAX(ABSEST) .LE. MAX(ABS(FINEST))*RELREQ WITH
C                     MAXCLS OR LESS FUNSUB CALLS MADE.
C             IFAIL=1 IF MAXCLS WAS TOO SMALL FOR D01EAF TO OBTAIN THE
C                     REQUIRED RELATIVE ACCURACY EPS.  IN THIS CASE
C                     D01EAF RETURNS VALUES OF FINEST WITH ESTIMATED
C                     ABSOLUTE ACCURACIES ABSEST.
C             IFAIL=2 IF LENWRK TOO SMALL FOR MAXCLS FUNCTION CALLS.
C                     IN THIS CASE D01EAF RETURNS VALUES OF FINEST WITH
C                     ESTIMATED ACCURACIES ABSEST USING THE WORKING
C                     STORAGE AVAILABLE.
C             IFAIL=3 RE-ENTRY WITH MAXCLS TOO SMALL TO MAKE ANY
C                     PROGRESS
C             IFAIL=4 IF MINCLS .GT. MAXCLS OR MAXCLS .LT. IRCLS
C                     OR LENWRK .LT. 8*NDIM + 11*NFUN + 3.
C     ******************************************************************
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='D01EAF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION  ABSREQ, RELREQ
      INTEGER           IFAIL, LENWRK, MAXCLS, MINCLS, NDIM, NFUN
C     .. Array Arguments ..
      DOUBLE PRECISION  A(NDIM), ABSEST(NFUN), B(NDIM), FINEST(NFUN),
     *                  WORK(LENWRK)
C     .. Subroutine Arguments ..
      EXTERNAL          FUNSUB
C     .. Local Scalars ..
      INTEGER           I1, I2, I3, I4, I5, I6, I7, I8, I9, IERROR,
     *                  IRCLS, MXRGNS, NREC
C     .. Local Arrays ..
      CHARACTER*80      P01REC(5)
C     .. External Functions ..
      INTEGER           P01ABF
      EXTERNAL          P01ABF
C     .. External Subroutines ..
      EXTERNAL          D01EAZ
C     .. Executable Statements ..
      IF (NDIM.LE.10) THEN
         IRCLS = 2**NDIM + 2*NDIM*(1+NDIM) + 1
      ELSE
         IRCLS = 1 + (NDIM*(12+2*(NDIM-1)*(3+(NDIM-2)*2)))/3
      END IF
      IF (NDIM.GE.1 .AND. NFUN.GE.1 .AND. MINCLS.LE.MAXCLS .AND.
     *    LENWRK.GE.8*NDIM+11*NFUN+3 .AND. IRCLS.LE.MAXCLS) THEN
         MXRGNS = (LENWRK-6*NDIM-9*NFUN)/(2*NDIM+2*NFUN+3)
         I1 = LENWRK - 2*NDIM - MXRGNS*(2*NDIM+2*NFUN+3) + 1
         I2 = I1 + MXRGNS
         I3 = I2 + MXRGNS
         I4 = I3 + MXRGNS
         I5 = I4 + MXRGNS*NFUN
         I6 = I5 + MXRGNS*NFUN
         I7 = I6 + MXRGNS*NDIM
         I8 = I7 + MXRGNS*NDIM
         I9 = I8 + NDIM
         CALL D01EAZ(NDIM,A,B,MINCLS,MAXCLS,NFUN,FUNSUB,ABSREQ,RELREQ,
     *               FINEST,ABSEST,I1-1,WORK,MXRGNS,WORK(I1),WORK(I2),
     *               WORK(I3),WORK(I4),WORK(I5),WORK(I6),WORK(I7),
     *               WORK(I8),WORK(I9),IRCLS,IERROR)
         IF (IERROR.GT.0) THEN
            IF (IERROR.EQ.1) WRITE (P01REC(1),FMT=99999)
     *          '** MAXCLS too small to obtain required accuracy'
            IF (IERROR.EQ.2) WRITE (P01REC(1),FMT=99999)
     *          '** LENWRK too small for the routine to continue'
            IF (IERROR.EQ.3) WRITE (P01REC(1),FMT=99999)
     *          '** MAXCLS too small to make any progress'
            NREC = 1
         END IF
      ELSE
         IERROR = 4
         WRITE (P01REC,FMT=99998) NDIM, MINCLS, ABSREQ, NFUN, MAXCLS,
     *     RELREQ, LENWRK, IRCLS, 8*NDIM + 11*NFUN + 3
         NREC = 5
         MINCLS = 0
      END IF
      IFAIL = P01ABF(IFAIL,IERROR,SRNAME,NREC,P01REC)
      RETURN
C
99999 FORMAT (1X,A)
99998 FORMAT (' ** On entry, one or more of the following parameter va',
     *  'lues is illegal',/'    NDIM =',I16,'  MINCLS =',I16,'  ABSREQ',
     *  ' =',1P,D10.2,/'    NFUN =',I16,'  MAXCLS =',I16,'  RELREQ =',
     *  1P,D10.2,/'  LENWRK =',I16,/'  MAXCLS must be at least',I10,
     *  '  LENWRK must be at least',I10)
      END
