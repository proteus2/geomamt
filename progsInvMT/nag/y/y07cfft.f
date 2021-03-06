      SUBROUTINE Y07CFF(JOB,N,A,TITLE,NSIG,NCOLS,NOUT)
C     MARK 13 RELEASE. NAG COPYRIGHT 1988.
C
C  Purpose
C  =======
C
C  Y07CFF  prints out the  triangular part  of  hermitian or  triangular
C  matrices using an E format on device NOUT. Each element is printed to
C  NSIG significant figures. A heading may be printed before the matrix.
C
C  The matrix  A  must be  presented as a  packed one dimensional array,
C  either with the upper triangle packed column by column,  or the lower
C  triangle packed row by row.
C
C  Parameters
C  ==========
C
C  JOB    - CHARACTER*1.
C
C           On entry,  JOB  specifies the  type of printing  as follows.
C
C           JOB = 'R' or 'r' or 'L' or 'l'
C                ( Row by row, Lower triangular )
C
C              The array A represents a lower triangle and so is printed
C              row by row.
C
C           JOB = 'C' or 'c' or 'U' or 'u'
C                ( Column by column, Upper triangular )
C
C              The  array  A  represents an  upper triangle  and  so  is
C              printed column by column.
C
C           Unchanged on exit.
C
C  N      - INTEGER.
C
C           On entry,  N specifies the order of the matrix A.  N must be
C           at least 1.
C
C           Unchanged on exit.
C
C  A      - COMPLEX             array    of     DIMENSION    at    least
C           ( ( n*( n + 1 ) )/2 ).
C
C           Before  entry  with  JOB = 'R' or 'r or 'L' or 'l',  A  must
C           contain the matrix to be printed packed sequentially, row by
C           row, so that  A( 1 ) contains  a( 1, 1 ),  A( 2 ) and A( 3 )
C           contain  a( 2, 1 ) and a( 2, 2 )  respectively,  and  so on.
C           Before  entry  with  JOB = 'C' or 'c' or 'U' or 'u', A  must
C           contain the matrix to be printed packed sequentially, column
C           by column,  so that  A( 1 ) contains  a( 1, 1 ),  A( 2 ) and
C           A( 3 ) contain a( 2, 1 ) and a( 2, 2 ) respectively,  and so
C           on.  Note that for a  symmetric matrix these packing schemes
C           are equivalent.
C
C           If JOB = 'R' or 'r' or 'L' or 'l', then if there is not room
C           on the line to print a complete row the heading  'Row i'  is
C           printed before the i(th) row of A. If JOB = 'C' or 'c or 'U'
C           or 'u',  then  if there is  not room on  the line to print a
C           a complete column the heading  'Col j' is printed before the
C           j(th) column of A.
C
C           Unchanged on exit.
C
C  TITLE  - CHARACTER  of  length  at least  1,  but  only  one  record.
C
C           On entry,  TITLE  specifies a  heading  to be printed before
C           printing the matrix  A.  Unless  TITLE  is blank,  TITLE  is
C           printed using the format
C
C              FORMAT( 1X, A )
C
C           and a  blank line  is  printed  following  the heading.  Any
C           trailing blanks in TITLE are not printed.
C
C           Unchanged on exit.
C
C  NSIG   - INTEGER.
C
C           On entry,  NSIG  specifies the number of significant figures
C           to which the elements of  A are printed. The field width for
C           each element of A will be 2*( NSIG + 7 ). If NSIG is outside
C           the range  ( 1, 92 )  then the  value 7  is used in place of
C           NSIG.
C
C           Unchanged on exit.
C
C  NCOLS  - INTEGER.
C
C           On entry,  NCOLS  specifies  the  maximum number of printing
C           positions per line. If NCOLS is not large enough to allow at
C           least one element per line,  or if NCOLS is greater than 132
C           then the value 72 is used in place of NCOLS.
C
C           Unchanged on exit.
C
C  NOUT   - INTEGER.
C
C           On entry,  NOUT specifies the device number for printing. If
C           NOUT  is negative then the value returned by the Nag Library
C           routine X04ABF is used in place of NOUT.
C
C           Unchanged on exit.
C
C  Further comments
C  ================
C
C  To print the elements of the  6 by 6 lower triangular matrix A,  to 4
C  significant figures,  on unit 6, with no more than 60 print positions
C  per line and the heading  'Lower triangle of A',  then  Y07CFF may be
C  called as
C
C     CALL Y07CFF( 'Row by row', 6, A, 'Lower triangle of A',
C    $             4, 60, 6 )
C
C  To get  the default values  for  NSIG, NCOLS and NOUT,  Y07CFF may be
C  called as
C
C     CALL Y07CFF( 'Row by row', 6, A, 'Lower triangle of A',
C    $             -1, -1, -1 )
C
C  Nag Fortran 77 auxilliary linear algebra routine.
C
C  -- Written on 10-October-1984.
C     Sven Hammarling, Nag Central Office.
C     This version dated 16-December-1987.
C
C
C     .. Scalar Arguments ..
      INTEGER           N, NCOLS, NOUT, NSIG
      CHARACTER*1       JOB
      CHARACTER*(*)     TITLE
C     .. Array Arguments ..
      COMPLEX*16        A(*)
C     .. Local Scalars ..
      INTEGER           I, IOUT, J, K, LENT, M, M1, M2, NC, NS
      LOGICAL           L
      CHARACTER*27      FRMAT
      CHARACTER*133     REC
C     .. External Subroutines ..
      EXTERNAL          X04BAF, Y07CAZ
C     .. Intrinsic Functions ..
      INTRINSIC         LEN, MIN
C     .. Executable Statements ..
      IOUT = NOUT
      NS = NSIG
      NC = NCOLS
C
C     Y07CAZ checks NOUT, NSIG and NCOLS and returns the format.
C     K gives the number of elements to be printed per line.
C
      CALL Y07CAZ(NS,NC,IOUT,FRMAT)
      K = NC/(2*(NS+7))
C
C     L is true if a row or column does not fit onto a single line.
C
      L = N .GT. K
C
C     Print the heading.
C
      DO 20 LENT = LEN(TITLE), 1, -1
         IF (TITLE(LENT:LENT).NE.' ') GO TO 40
   20 CONTINUE
   40 CONTINUE
      IF (LENT.GT.0) THEN
         WRITE (REC,FMT=99999) TITLE(1:LENT)
         CALL X04BAF(IOUT,REC)
         IF ( .NOT. L) CALL X04BAF(IOUT,' ')
      END IF
C
C     Print the matrix.
C
      M = 1
      IF ((JOB.EQ.'R') .OR. (JOB.EQ.'r') .OR. (JOB.EQ.'L')
     *    .OR. (JOB.EQ.'l')) THEN
         DO 80 I = 1, N
            IF (L) THEN
               WRITE (REC,FMT=99998) I
               CALL X04BAF(IOUT,' ')
               CALL X04BAF(IOUT,REC)
            END IF
            DO 60 J = 1, I, K
               M1 = M
               M2 = M + MIN(J+K-1,I) - J
               WRITE (REC,FMT=FRMAT) (A(M),M=M1,M2)
               CALL X04BAF(IOUT,REC)
   60       CONTINUE
   80    CONTINUE
      ELSE IF ((JOB.EQ.'C') .OR. (JOB.EQ.'c') .OR. (JOB.EQ.'U')
     *         .OR. (JOB.EQ.'u')) THEN
         DO 120 J = 1, N
            IF (L) THEN
               WRITE (REC,FMT=99997) J
               CALL X04BAF(IOUT,' ')
               CALL X04BAF(IOUT,REC)
            END IF
            DO 100 I = 1, J, K
               M1 = M
               M2 = M + MIN(I+K-1,J) - I
               WRITE (REC,FMT=FRMAT) (A(M),M=M1,M2)
               CALL X04BAF(IOUT,REC)
  100       CONTINUE
  120    CONTINUE
      END IF
      CALL X04BAF(IOUT,' ')
      CALL X04BAF(IOUT,' ')
      RETURN
C
C     End of Y07CFF. ( CPMPRE )
C
99999 FORMAT (1X,A)
99998 FORMAT (' Row ',I5)
99997 FORMAT (' Col ',I5)
      END
