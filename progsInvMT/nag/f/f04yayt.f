      SUBROUTINE F04YAY(JOB,N,T,NRT,B,IDIAG)
C     MARK 11 RELEASE. NAG COPYRIGHT 1983.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C
C     PURPOSE
C     =======
C
C     F04YAY SOLVES SYSTEMS OF TRIANGULAR EQUATIONS.
C
C     IMPORTANT.  IN DOUBLE PRECISION IMPLEMENTATIONS THE REAL
C     ---------   DECLARATIONS SHOULD BE INTERPRETED TO MEAN
C              DOUBLE PRECISION.
C
C     DESCRIPTION
C     ===========
C
C     F04YAY SOLVES THE EQUATIONS
C
C     T*X = B ,   OR   ( T**T )*X = B ,
C
C     WHERE T IS AN N BY N UPPER OR LOWER TRIANGULAR MATRIX.
C
C     THE TYPE OF TRIANGULAR SYSTEM SOLVED IS CONTROLLED BY THE
C     PARAMETER JOB AS DESCRIBED IN THE PARAMETER SECTION BELOW.
C
C     PARAMETERS
C     ==========
C
C     JOB   - INTEGER.
C          ON ENTRY, JOB MUST CONTAIN ONE OF THE VALUES -2, -1, 0, 1, 2
C          TO SPECIFY THE TYPE OF TRIANGULAR SYSTEM TO BE SOLVED AS
C          FOLLOWS.
C
C          JOB =  0  T IS ASSUMED TO BE DIAGONAL AND THE
C                    EQUATIONS T*X = B ARE SOLVED.
C
C          JOB =  1  T IS ASSUMED TO BE UPPER TRIANGULAR AND THE
C                    EQUATIONS T*X = B ARE SOLVED.
C
C          JOB = -1  T IS ASSUMED TO BE UPPER TRIANGULAR AND THE
C                    EQUATIONS ( T**T )*X = B ARE SOLVED.
C
C          JOB =  2  T IS ASSUMED TO BE LOWER TRIANGULAR AND THE
C                    EQUATIONS T*X = B ARE SOLVED.
C
C          JOB = -2  T IS ASSUMED TO BE LOWER TRIANGULAR AND THE
C                    EQUATIONS ( T**T )*X = B ARE SOLVED.
C
C          UNCHANGED ON EXIT.
C
C     N     - INTEGER.
C          ON ENTRY, N SPECIFIES THE ORDER OF THE MATRIX T. N MUST BE AT
C          LEAST UNITY.
C          UNCHANGED ON EXIT.
C
C     T     - REAL ARRAY OF DIMENSION ( NRT, NCT ). NCT MUST BE AT LEAST
C          N.
C          BEFORE ENTRY T MUST CONTAIN THE TRIANGULAR ELEMENTS. ONLY
C          THOSE ELEMENTS CONTAINED IN THE TRIANGULAR PART OF T ARE
C          REFERENCED BY THIS ROUTINE.
C          UNCHANGED ON EXIT.
C
C     NRT   - INTEGER.
C          ON ENTRY, NRT SPECIFIES THE FIRST DIMENSION OF T AS DECLARED
C          IN THE CALLING (SUB) PROGRAM. NRT MUST BE AT LEAST N.
C          UNCHANGED ON EXIT.
C
C     B     - REAL ARRAY OF DIMENSION ( N ).
C          BEFORE ENTRY, B MUST CONTAIN THE RIGHT HAND SIDE OF THE
C          EQUATIONS TO BE SOLVED.
C          ON SUCCESSFUL EXIT, B CONTAINS THE SOLUTION VECTOR X.
C
C     IDIAG - INTEGER.
C          BEFORE ENTRY, IDIAG MUST BE ASSIGNED A VALUE. FOR USERS
C          UNFAMILIAR WITH THIS PARAMETER (DESCRIBED IN CHAPTER P01)
C          THE RECOMMENDED VALUE IS ZERO.
C          ON SUCCESSFUL EXIT IDIAG WILL BE ZERO. A POSITIVE VALUE
C          OF IDIAG DENOTES AN ERROR AS FOLLOWS.
C
C          IDIAG = 1     ONE OF THE INPUT PARAMETERS N, OR NRT, OR JOB
C                        HAS BEEN INCORRECTLY SPECIFIED.
C
C          IDIAG .GT. 1  THE (IDIAG - 1)TH DIAGONAL ELEMENT OF T IS
C                        EITHER ZERO OR IS TOO SMALL TO AVOID OVERFLOW
C                        IN COMPUTING AN ELEMENT OF X.
C
C     FURTHER COMMENTS
C     ================
C
C     IF T IS PART OF A MATRIX A PARTITIONED AS
C
C     A = ( A1  A2 ) ,
C         ( A3  T  )
C
C     WHERE A1 IS AN M BY K MATRIX ( M.GE.0, K.GE.0), THEN THIS ROUTINE
C     MAY BE CALLED WITH THE PARAMETER T AS A( M + 1, K + 1 ) AND NRT AS
C     THE FIRST DIMENSION OF A AS DECLARED IN THE CALLING (SUB) PROGRAM.
C
C     NAG FORTRAN 66 AUXILIARY LINEAR ALGEBRA ROUTINE. ( TSOLVE. )
C     THE FURTHER COMMENT DOES NOT APPLY TO THE FORTRAN 66 VERSION.
C
C     -- WRITTEN ON 26-OCTOBER-1982.  S.J.HAMMARLING.
C
C     .. Parameters ..
      CHARACTER*6       SRNAME
      PARAMETER         (SRNAME='F04YAY')
C     .. Scalar Arguments ..
      INTEGER           IDIAG, JOB, N, NRT
C     .. Array Arguments ..
      DOUBLE PRECISION  B(N), T(NRT,N)
C     .. Arrays in Common ..
      DOUBLE PRECISION  WMACH(15)
C     .. Local Scalars ..
      DOUBLE PRECISION  ZERO
      INTEGER           J, JJ, K, KK
      LOGICAL           FAIL
C     .. Local Arrays ..
      CHARACTER*1       P01REC(1)
C     .. External Functions ..
      DOUBLE PRECISION  DDOT, F06BLF
      INTEGER           P01ABF
      EXTERNAL          DDOT, F06BLF, P01ABF
C     .. External Subroutines ..
      EXTERNAL          DAXPY, X02ZAZ
C     .. Intrinsic Functions ..
      INTRINSIC         ABS
C     .. Common blocks ..
      COMMON            /AX02ZA/WMACH
C     .. Save statements ..
      SAVE              /AX02ZA/
C     .. Data statements ..
      DATA              ZERO/0.0D+0/
C     .. Executable Statements ..
C
      IF (N.GE.1 .AND. NRT.GE.N .AND. ABS(JOB).LE.2) GO TO 20
      IDIAG = P01ABF(IDIAG,1,SRNAME,0,P01REC)
      RETURN
   20 CONTINUE
C
      CALL X02ZAZ
C
      IF (JOB.EQ.1 .OR. JOB.EQ.(-2)) GO TO 60
      DO 40 K = 1, N
         IF (B(K).NE.ZERO) GO TO 100
   40 CONTINUE
      GO TO 300
   60 CONTINUE
      DO 80 KK = 1, N
         K = N - KK + 1
         IF (B(K).NE.ZERO) GO TO 100
   80 CONTINUE
      GO TO 300
  100 CONTINUE
      IF (JOB.NE.0) GO TO 140
      DO 120 J = K, N
C
         B(J) = F06BLF(B(J),T(J,J),FAIL)
         IF (FAIL) GO TO 320
C
  120 CONTINUE
      GO TO 300
  140 IF (JOB.NE.1) GO TO 180
      DO 160 JJ = 1, K
         J = K - JJ + 1
C
         B(J) = F06BLF(B(J),T(J,J),FAIL)
         IF (FAIL) GO TO 320
C
         IF (J.GT.1) CALL DAXPY(J-1,-B(J),T(1,J),1,B,1)
C
  160 CONTINUE
      GO TO 300
  180 IF (JOB.NE.2) GO TO 220
      DO 200 J = K, N
C
         B(J) = F06BLF(B(J),T(J,J),FAIL)
         IF (FAIL) GO TO 320
C
         IF (J.LT.N) CALL DAXPY(N-J,-B(J),T(J+1,J),1,B(J+1),1)
C
  200 CONTINUE
      GO TO 300
  220 IF (JOB.NE.(-1)) GO TO 260
      DO 240 J = K, N
C
         IF (J.GT.1) B(J) = B(J) - DDOT(J-1,T(1,J),1,B,1)
C
         B(J) = F06BLF(B(J),T(J,J),FAIL)
         IF (FAIL) GO TO 320
C
  240 CONTINUE
      GO TO 300
  260 CONTINUE
      DO 280 JJ = 1, K
         J = K - JJ + 1
C
         IF (J.LT.N) B(J) = B(J) - DDOT(N-J,T(J+1,J),1,B(J+1),1)
C
         B(J) = F06BLF(B(J),T(J,J),FAIL)
         IF (FAIL) GO TO 320
C
  280 CONTINUE
  300 CONTINUE
C
      IDIAG = 0
      RETURN
C
  320 IDIAG = P01ABF(IDIAG,J+1,SRNAME,0,P01REC)
      RETURN
C
C     END OF F04YAY.
C
      END
