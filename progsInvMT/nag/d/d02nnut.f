      SUBROUTINE D02NNU(N,IWK,WK,RHS,PATH,IFAIL)
C     MARK 12 RELEASE. NAG COPYRIGHT 1986.
C     MARK 12B REVISED. IER-527 (FEB 1987).
C-----------------------------------------------------------------------
C      THIS ROUTINE INTERFACES TO THE NAG ROUTINES :
C         F01BRF - LU DECOMPOSITION OF SPARSE MATRIX , PERMUTING TO
C                  BLOCK LOWER TRIANGULAR FORM AND USING  PARTIAL
C                  PIVOTING
C         F01BSF - USES DECOMPOSITION FROM A PREVIOUS CALL TO F01BSF
C                  TO DECOMPOSE A MATRIX OF THE SAME SPARSITY PATTERN
C         F04AXF - SOLVES THE LINEAR SYSTEMS A X = B , A(TR) X = B
C                  USING A DECOMPOSITION SUPPLIED BY THE PREVIOUS
C                  CALL TO F01BRF OR F01BSF
C
C      INPUTS :
C   N     THE NUMBER OF LINEAR EQUATIONS
C   WK    ARRAY CONTAINING SPARSE MATRIX , OR ITS DECOMPOSITION , AND
C         ALSO WORKSPACE
C   IWK   INTEGER ARRAY CONTAINING POINTERS AND OTHER PERTINENT
C         INFORMATION
C   RHS   RIGHTHAND SIDE OF LINEAR SYSTEM A X = B
C   PATH  INTEGER WHICH INDICATES WHAT ACTION IS TO BE TAKEN
C            = 1 : DECOMPOSE A NEW SPARSITY STRUCTURE
C            = 2 : DECOMPOSE A NEW MATRIX USING OLD SPARSITY STRUCTURE
C            = 3 : SOLVE A(TR) X = B
C  ABORT LOGICAL ARRAY TO CONTROL RETURNS FROM F01BRF/F01BSF
C    FOR F01BRF :
C        ABORT(1) = .TRUE. : THE ROUTINE EXITS IMMEADIATELY ON DETECTING
C                            STRUCTURAL SINGULARITY
C        ABORT(2) = .TRUE. : THE ROUTINE EXITS IMMEADIATELY ON DETECTING
C                            NUMERICAL SINGULARITY
C        ABORT(3) = .FALSE.: ROUTINE CONTINUES IF NOT ENOUGH STORE BY
C                            DROPPING ELEMENTS FROM THE DECOMPOSITION.
C                            THEN IDISP(6:7) GIVE A GUIDE AS TO HOW MUCH
C                            STORE IS ACTUALLY REQUIRED.
C    FOR ROUTINES F01BRF AND F01BSF
C        ABORT(4) = .TRUE. : THE ROUTINE EXITS IMMEADIATELY ON DETECTING
C                            DUPLICATE ELEMENTS
C  IFAIL ERROR MESSAGE INDICATOR
C
C  THIS ROUTINE ALSO USES OTHER VARIABLES IN COMMON
C-----------------------------------------------------------------------
C HD02NN
C   IDISP(1) AND IDISP(2) INDICATE THE FIRST AND LAST ELEMENTS OF THE
C   DECOMPOSITION OF THE DIAGONAL BLOCKS (ICN+IDISP(1) AND ICN+IDISP(2))
C   IN IWK). THEY MUST NOT BE CHANGED BETWEEN A CALL OF F01BRF AND CALLS
C   TO F01BSF AND F04AXF.
C   IDIDP(3) AND IDISP(4) GIVE THE NUMBER IF TIMES THE DATA HAS BEEN
C   COMPRESSED DURING THE DECOMPOSITION TO RELEASE TO MORE STORE.
C   IDISP(5) IS AN UPPER BOUND OF THE MATRIX
C   IDISP(6) AND IDISP(7) GIVE THE MINIMUM SIZES OF LIRN AND LICN
C   RESPECTIVELY  (NOTE WITHOUT 'ELBOW ROOM').
C   IF (LBLOCK) THEN IDISP(8:10) USED
C   IDISP(8) IS STRUCTURAL RANK OF THE MATRIX
C   IDISP(9) GIVES THE THE NUMBER OF DIAGONAL BLOCKS.
C   IDISP(10) IS THE SIZE OF THE LARGEST DIAGONAL BLOCK.
C     .. Scalar Arguments ..
      INTEGER           IFAIL, N, PATH
C     .. Array Arguments ..
      DOUBLE PRECISION  RHS(*), WK(*)
      INTEGER           IWK(*)
C     .. Scalars in Common ..
      DOUBLE PRECISION  ETA, RGROW, U
      INTEGER           IBA, IBIAN, IBJAN, IBJGP, ICN, IDEV, IESP,
     *                  IKEEP, IPA, IPC, IPIAN, IPIC, IPIGP, IPISP,
     *                  IPIWK, IPJAN, IPJGP, IPLOST, IPR, IPRSP, IPRWK,
     *                  IRN, ISPIWK, ISPRWK, ISTATC, ITRACE, IYS, LENWK,
     *                  LICN, LIRN, LRAT, LREQ, LREST, LWMIN, MOSS,
     *                  MSBJ, NGP, NLU, NNZ, NSLJ, NSP
      LOGICAL           COPYPT, GROW, LBLOCK
C     .. Arrays in Common ..
      DOUBLE PRECISION  RLSS(6)
      INTEGER           IDISP(10)
      LOGICAL           ABORT(4)
C     .. Local Scalars ..
      DOUBLE PRECISION  RESID, RPMIN
      INTEGER           I, J, LSTNTR, NENTRS
C     .. External Subroutines ..
      EXTERNAL          D02NNS, D02NNT, F01BRF, F01BSF, F04AXF
C     .. Common blocks ..
      COMMON            /AD02NM/ITRACE, IDEV
      COMMON            /BD02NN/RLSS, IPLOST, IESP, ISTATC, IYS, IBA,
     *                  IBIAN, IBJAN, IBJGP, IPIAN, IPJAN, IPJGP, IPIGP,
     *                  IPR, IPC, IPIC, IPISP, IPRSP, IPA, LENWK, LREQ,
     *                  LRAT, LREST, LWMIN, MOSS, MSBJ, NSLJ, NGP, NLU,
     *                  NNZ, NSP
      COMMON            /DD02NN/IKEEP, IPIWK, IPRWK, IRN, LIRN, ICN,
     *                  LICN, ISPRWK, ISPIWK
      COMMON            /HD02NN/IDISP
      COMMON            /JD02NN/U, ETA, RGROW, LBLOCK, GROW, ABORT
      COMMON            /KD02NN/COPYPT
C     .. Save statement ..
      SAVE              /BD02NN/, /DD02NN/, /HD02NN/, /JD02NN/,
     *                  /AD02NM/, /KD02NN/
C     .. Executable Statements ..
C     CHECK FOR VALID PATH SPECIFICATION
      IF (PATH.LT.1 .OR. PATH.GT.3) THEN
         IFAIL = -3
         RETURN
      END IF
      IF (PATH.EQ.3) GO TO 80
      RGROW = 0.0D0
      IF (COPYPT) THEN
C        WRITE(6,99999)
C9999    FORMAT(' ***  EXPANDING ROW POINTERS  ***')
C
C EXPAND ROW POINTERS
C     INTO IWK(IRN,...,IRN+NNZ-1)  ( FROM IWK(IPJAN,...,IPJAN+N) )
C       THIS ORDER IS DESTROYED BY F01BRF AND IS NOT REQUIRED AFTER
C       HENCE THIS OPERATION IS REPEATED BEFORE CALLING F01BSF
C
         LSTNTR = IRN + NNZ
         IBIAN = IPIAN - 1
         DO 40 I = N, 1, -1
            NENTRS = IWK(IPIAN+I) - IWK(IBIAN+I)
            DO 20 J = 1, NENTRS
               IWK(LSTNTR-J) = I
   20       CONTINUE
            LSTNTR = LSTNTR - NENTRS
   40    CONTINUE
      END IF
C
C  WE SUPPRESS NAG ERROR DIAGNOSTICS FROM F01BRF/F01BSF AND THEREFORE
C     MAKE OUR OWN CHECKS BEFORE ENTERING THESE ROUTINES :
C      N .LE. 0
C      NNZ .LE. 0
C      LIRN .LT. NNZ
C      LICN .LT. NNZ
C      ROW/COL POINTERS OUTSIDE RANGE 1,N
C      DUPLICATE ELEMENTS
C
      IFAIL = 0
      CALL D02NNT(N,NNZ,LICN,LIRN,IWK(IRN),IWK(IPJAN),IWK(IPIWK),
     *            IWK(IPIAN),WK(IPA),IFAIL)
C
      IF (IFAIL.GT.0) RETURN
C
      IFAIL = 1
C
      IF (PATH.EQ.2) GO TO 60
C
C**** LU DECOMP WITH NEW SPARSITY USING F01BRF
C
      CALL F01BRF(N,NNZ,WK(IPA),LICN,IWK(IRN),LIRN,IWK(ICN),U,IWK(IKEEP)
     *            ,IWK(IPIWK),WK(IPRWK),LBLOCK,GROW,ABORT,IDISP,IFAIL)
C
      IF (GROW .AND. IFAIL.EQ.0) RGROW = WK(IPRWK)
C
      IF (IFAIL.EQ.0) CALL D02NNS
C
      RETURN
C
C**** LU DECOMP WITH OLD SPARSITY USING F01BSF
C
   60 CONTINUE
      CALL F01BSF(N,NNZ,WK(IPA),LICN,IWK(IRN),IWK(IPJAN),IWK(ICN),
     *            IWK(IKEEP),IWK(IPIWK),WK(IPRWK),GROW,ETA,RPMIN,
     *            ABORT(4),IDISP,IFAIL)
C
      IF (GROW .AND. IFAIL.EQ.0) RGROW = WK(IPRWK)
      COPYPT = .FALSE.
C
      RETURN
C
C**** SOLVE A(TR) X = B  USING F04AXF
C
   80 CONTINUE
C
      IFAIL = 0
C               SINCE THERE ARE NO ERROR RETURNS FROM F04AXF
      CALL F04AXF(N,WK(IPA),LICN,IWK(ICN),IWK(IKEEP),RHS,WK(IPRWK),0,
     *            IDISP,RESID)
C
      RETURN
C
      END
