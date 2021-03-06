      SUBROUTINE D02NNM(INLN)
C     MARK 13 RE-ISSUE. NAG COPYRIGHT 1988.
C     .. Scalar Arguments ..
      INTEGER           INLN
C     .. Local Scalars ..
      INTEGER           IDEV
      CHARACTER*80      REC
C     .. External Subroutines ..
      EXTERNAL          X04ABF, X04BAF
C     .. Executable Statements ..
      CALL X04ABF(0,IDEV)
      GO TO (20,40,60,80,100,120,140,160) INLN
   20 WRITE (REC,FMT=99999)
      CALL X04BAF(IDEV,REC)
      GO TO 180
   40 WRITE (REC,FMT=99998)
      CALL X04BAF(IDEV,REC)
      GO TO 180
   60 WRITE (REC,FMT=99997)
      CALL X04BAF(IDEV,REC)
      GO TO 180
   80 WRITE (REC,FMT=99996)
      CALL X04BAF(IDEV,REC)
      WRITE (REC,FMT=99995)
      CALL X04BAF(IDEV,REC)
      GO TO 180
  100 WRITE (REC,FMT=99994)
      CALL X04BAF(IDEV,REC)
      WRITE (REC,FMT=99993)
      CALL X04BAF(IDEV,REC)
      GO TO 180
  120 WRITE (REC,FMT=99992)
      CALL X04BAF(IDEV,REC)
      GO TO 180
  140 WRITE (REC,FMT=99991)
      CALL X04BAF(IDEV,REC)
      WRITE (REC,FMT=99990)
      CALL X04BAF(IDEV,REC)
      GO TO 180
  160 WRITE (REC,FMT=99989)
      CALL X04BAF(IDEV,REC)
  180 CONTINUE
      RETURN
C
99999 FORMAT (' SOLVE SYSTEM WITH NEW JACOBIAN')
99998 FORMAT (' SOLVE SYSTEM WITH OLD JACOBIAN')
99997 FORMAT (' PERFORM A RESIDUAL EVALUATION')
99996 FORMAT (' PERFORM BACK-SUBSTITUTION ON THE CONTENTS ')
99995 FORMAT (' OF THE RESIDUAL VECTOR')
99994 FORMAT (' PERFORM A RESIDUAL EVALUATION AND')
99993 FORMAT (' BACK-SUBSTITUTION FOR THE PETZOLD ERROR TEST')
99992 FORMAT (' SOLVE SYSTEM USING FUNCTIONAL ITERATION')
99991 FORMAT (' SOLVE FOR INITIAL VALUES OF THE SOLUTION')
99990 FORMAT (' AND ITS DERIVATIVES USING FUNCTIONAL ITERATION ')
99989 FORMAT (' PERFORM A RESIDUAL EVALUATION WITH IRES = -1 ')
      END
