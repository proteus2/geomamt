      SUBROUTINE E04NBS(NERROR,MSGLVL,LCRASH,USERKX,LIWORK,LWORK,LITOTL,
     *                  LWTOTL,N,NCLIN,ISTATE,KX,NAMED,NAMES,BIGBND,BL,
     *                  BU,LPROB,LDC,LDA,M,NERR,IFAIL)
C     MARK 16 RELEASE. NAG COPYRIGHT 1993.
C     MARK 17 REVISED. IER-1570 (JUN 1995).
C
C     ******************************************************************
C     E04NBS   checks the input data for E04NCF.
C
C     Systems Optimization Laboratory, Stanford University.
C     Original Fortran 66 version written 10-May-1980.
C     Fortran 77 version written  5-October-1984.
C     This version of E04NBS dated  21-Mar-93.
C     ******************************************************************
C
C     .. Scalar Arguments ..
      DOUBLE PRECISION  BIGBND
      INTEGER           IFAIL, LCRASH, LDA, LDC, LITOTL, LIWORK, LPROB,
     *                  LWORK, LWTOTL, M, MSGLVL, N, NCLIN, NERR, NERROR
      LOGICAL           NAMED, USERKX
C     .. Array Arguments ..
      DOUBLE PRECISION  BL(N+NCLIN), BU(N+NCLIN)
      INTEGER           ISTATE(N+NCLIN), KX(N)
      CHARACTER*8       NAMES(*)
C     .. Scalars in Common ..
      INTEGER           IPRINT, ISUMM, LINES1, LINES2, NOUT
C     .. Local Scalars ..
      DOUBLE PRECISION  B1, B2
      INTEGER           IERR, IS, J, K, L
      LOGICAL           OK
C     .. Local Arrays ..
      CHARACTER*5       ID(3)
      CHARACTER*80      REC(4)
C     .. External Subroutines ..
      EXTERNAL          M01ZBF, X04BAY
C     .. Intrinsic Functions ..
      INTRINSIC         ABS, MAX
C     .. Common blocks ..
      COMMON            /AE04NB/NOUT, IPRINT, ISUMM, LINES1, LINES2
C     .. Data statements ..
      DATA              ID(1), ID(2), ID(3)/'Varbl', 'L Con', 'N Con'/
C     .. Executable Statements ..
C
      NERROR = 0
C
C     ------------------------------------------------------------------
C     Check  M.
C     ------------------------------------------------------------------
      IF (LPROB.GE.3) THEN
         IF (M.LE.0) THEN
            NERROR = NERROR + 1
            IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
               WRITE (REC,FMT=99997) M
               CALL X04BAY(NERR,3,REC)
            END IF
         END IF
      END IF
C
C     ------------------------------------------------------------------
C     Check  N.
C     ------------------------------------------------------------------
      IF (N.LE.0) THEN
         NERROR = NERROR + 1
         IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
            WRITE (REC,FMT=99996) N
            CALL X04BAY(NERR,3,REC)
         END IF
      END IF
C
C     ------------------------------------------------------------------
C     Check  NCLIN.
C     ------------------------------------------------------------------
      IF (NCLIN.LT.0) THEN
         NERROR = NERROR + 1
         IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
            WRITE (REC,FMT=99995) NCLIN
            CALL X04BAY(NERR,3,REC)
         END IF
      END IF
C
C     ------------------------------------------------------------------
C     Check  LDC.
C     ------------------------------------------------------------------
      IF (LDC.LT.MAX(1,NCLIN)) THEN
         NERROR = NERROR + 1
         IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
            WRITE (REC,FMT=99994) LDC, NCLIN
            CALL X04BAY(NERR,3,REC)
         END IF
      END IF
C
C     ------------------------------------------------------------------
C     Check  LDA.
C     ------------------------------------------------------------------
      IF (LDA.LT.MAX(1,M)) THEN
         NERROR = NERROR + 1
         IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
            WRITE (REC,FMT=99993) LDA, M
            CALL X04BAY(NERR,3,REC)
         END IF
      END IF
C
C     ------------------------------------------------------------------
C     Check if there is enough workspace to solve the problem.
C     ------------------------------------------------------------------
      OK = LITOTL .LE. LIWORK .AND. LWTOTL .LE. LWORK
      IF ( .NOT. OK) THEN
         NERROR = NERROR + 1
         IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
            WRITE (REC,FMT=99999) LIWORK, LWORK, LITOTL, LWTOTL
            CALL X04BAY(NERR,3,REC)
            WRITE (REC,FMT=99998)
            CALL X04BAY(NERR,2,REC)
         END IF
      ELSE IF (MSGLVL.GT.0) THEN
         WRITE (REC,FMT=99999) LIWORK, LWORK, LITOTL, LWTOTL
         CALL X04BAY(IPRINT,3,REC)
      END IF
C
      IF (NERROR.EQ.0) THEN
C
         IF (USERKX) THEN
C           ------------------------------------------------------------
C           Check for a valid KX.
C           ------------------------------------------------------------
            IERR = 1
            CALL M01ZBF(KX,1,N,IERR)
            IF (IERR.NE.0) THEN
               NERROR = NERROR + 1
               IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
                  WRITE (REC,FMT=99992)
                  CALL X04BAY(NERR,2,REC)
               END IF
            END IF
         END IF
C
C        ---------------------------------------------------------------
C        Check the bounds on all variables and constraints.
C        ---------------------------------------------------------------
         DO 20 J = 1, N + NCLIN
            B1 = BL(J)
            B2 = BU(J)
            OK = B1 .LT. B2 .OR. (B1.EQ.B2 .AND. ABS(B1).LT.BIGBND)
            IF ( .NOT. OK) THEN
               NERROR = NERROR + 1
               IF (J.GT.N+NCLIN) THEN
                  K = J - N - NCLIN
                  L = 3
               ELSE IF (J.GT.N) THEN
                  K = J - N
                  L = 2
               ELSE
                  K = J
                  L = 1
               END IF
               IF (NAMED) THEN
                  IF (B1.EQ.B2) THEN
                     IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
                        WRITE (REC,FMT=99991) NAMES(J), J, J, B1, BIGBND
                        CALL X04BAY(NERR,4,REC)
                     END IF
                  ELSE
                     IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
                        WRITE (REC,FMT=99990) NAMES(J), J, B1, J, B2
                        CALL X04BAY(NERR,3,REC)
                     END IF
                  END IF
               ELSE
                  IF (B1.EQ.B2) THEN
                     IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
                        WRITE (REC,FMT=99989) ID(L), K, J, J, B1, BIGBND
                        CALL X04BAY(NERR,4,REC)
                     END IF
                  ELSE
                     IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
                        WRITE (REC,FMT=99988) ID(L), K, J, B1, J, B2
                        CALL X04BAY(NERR,3,REC)
                     END IF
                  END IF
               END IF
            END IF
   20    CONTINUE
C
C        ---------------------------------------------------------------
C        If warm start, check  ISTATE.
C        ---------------------------------------------------------------
         IF (LCRASH.EQ.1) THEN
            DO 40 J = 1, N + NCLIN
               IS = ISTATE(J)
               OK = IS .GE. (-2) .AND. IS .LE. 4
               IF ( .NOT. OK) THEN
                  NERROR = NERROR + 1
                  IF (IFAIL.EQ.0 .OR. IFAIL.EQ.-1) THEN
                     WRITE (REC,FMT=99987) J, J, IS
                     CALL X04BAY(NERR,3,REC)
                  END IF
               END IF
   40       CONTINUE
         END IF
      END IF
C
      RETURN
C
C
C     End of  E04NBS.
C
99999 FORMAT (/' Workspace provided is     IWORK(',I8,'),  WORK(',I8,
     *       ').',/' To solve problem we need  IWORK(',I8,'),  WORK(',
     *       I8,').')
99998 FORMAT (/' ** Not enough workspace to solve problem.')
99997 FORMAT (/' ** On entry, M.le.0:',/'    M = ',I16)
99996 FORMAT (/' ** On entry, N.le.0:',/'    N = ',I16)
99995 FORMAT (/' ** On entry, NCLIN.lt.0:',/'    NCLIN = ',I16)
99994 FORMAT (/' ** On entry, LDC.lt.max(1,NCLIN):',/'    LDC = ',I16,
     *       '   NCLIN = ',I16)
99993 FORMAT (/' ** On entry, LDA.lt.max(1,M):',/'    LDA = ',I16,'   ',
     *       'M = ',I16)
99992 FORMAT (/' ** On entry, KX has not been supplied as a valid perm',
     *       'utation.')
99991 FORMAT (/' ** On entry, the equal bounds on  ',A8,'  are infinit',
     *       'e (because',/'    BL(',I4,').eq.beta and BU(',I4,').eq.b',
     *       'eta, but abs(beta).ge.bigbnd):',/'    beta =',G16.7,' bi',
     *       'gbnd =',G16.7)
99990 FORMAT (/' ** On entry, the bounds on  ',A8,'  are inconsistent:',
     *       /'    BL(',I4,') =',G16.7,'   BU(',I4,') =',G16.7)
99989 FORMAT (/' ** On entry, the equal bounds on  ',A5,I3,'  are infi',
     *       'nite (because',/'    BL(',I4,').eq.beta and BU(',I4,').e',
     *       'q.beta, but abs(beta).ge.bigbnd):',/'    beta =',G16.7,
     *       ' bigbnd =',G16.7)
99988 FORMAT (/' ** On entry, the bounds on  ',A5,I3,'  are inconsiste',
     *       'nt:',/'    BL(',I4,') =',G16.7,'   BU(',I4,') =',G16.7)
99987 FORMAT (/' ** On entry with a Warm Start, ISTATE(',I4,') is out ',
     *       'of range:',/'    ISTATE(',I4,') = ',I16)
      END
