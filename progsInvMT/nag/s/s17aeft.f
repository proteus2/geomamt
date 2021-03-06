      DOUBLE PRECISION FUNCTION S17AEF(X,IFAIL)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978.
C     MARK 7C REVISED IER-185 (MAY 1979)
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     BESSEL FUNCTION J0(X)
C
C     **************************************************************
C
C     TO EXTRACT THE CORRECT CODE FOR A PARTICULAR MACHINE-RANGE,
C     ACTIVATE THE STATEMENTS CONTAINED IN COMMENTS BEGINNING  CDD ,
C     WHERE  DD  IS THE APPROXIMATE NUMBER OF SIGNIFICANT DECIMAL
C     DIGITS REPRESENTED BY THE MACHINE
C     DELETE THE ILLEGAL DUMMY STATEMENTS OF THE FORM
C     * EXPANSION (NNNN) *
C
C     NOTE - THE VALUE OF THE CONSTANT XBIG (DEFINED IN A DATA
C     STATEMENT) SHOULD BE REDUCED IF NECESSARY TO ENSURE THAT SIN
C     AND COS WILL RETURN A RESULT WITHOUT AN EXECUTION ERROR FOR
C     ALL ARGUMENTS X SUCH THAT ABS(X) .LE. XBIG
C
C     **************************************************************
C
C     .. Parameters ..
      CHARACTER*6                      SRNAME
      PARAMETER                        (SRNAME='S17AEF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION                 X
      INTEGER                          IFAIL
C     .. Local Scalars ..
      DOUBLE PRECISION                 A, B, C, CX, G, SX, T, T2, TBPI,
     *                                 XBIG, XVSMAL, Y
C     .. Local Arrays ..
      CHARACTER*1                      P01REC(1)
C     .. External Functions ..
      INTEGER                          P01ABF
      EXTERNAL                         P01ABF
C     .. Intrinsic Functions ..
      INTRINSIC                        ABS, COS, SIN, SQRT
C     .. Data statements ..
C08   DATA XBIG,XVSMAL,TBPI/1.0D+7,1.0D-4,6.36619772D-1/
C09   DATA XBIG,XVSMAL,TBPI/1.0D+8,3.2D-5,6.366197724D-1/
C12   DATA XBIG,XVSMAL,TBPI/1.0D+11,1.0D-6,6.366197723676D-1/
C15   DATA XBIG,XVSMAL,TBPI/1.0D+14,3.2D-8,6.366197723675813D-1/
      DATA XBIG,XVSMAL,TBPI/1.0D+16,3.2D-9,6.36619772367581343D-1/
C19   DATA XBIG,XVSMAL,TBPI/1.0D+18,3.2D-10,6.3661977236758134308D-1/
C     .. Executable Statements ..
C
      T = ABS(X)
C     ERROR 1 TEST
      IF (T.GT.XBIG) GO TO 60
      IFAIL = 0
C     X RANGE TEST
      IF (T.GT.8.0D0) GO TO 40
C     SMALL X
C      TEST FOR VERY SMALL X
      IF (T.GT.XVSMAL) GO TO 20
      S17AEF = 1.0D0
      GO TO 80
   20 T = 3.125D-2*T*T - 1.0D0
      T2 = 2.0D0*T
C
C      * EXPANSION (0027) *
C
C     EXPANSION (0027) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   A = -2.67925353D-9
C08   B = T2*A + 7.60816359D-8
C08   C = T2*B - A - 1.76194691D-6
C08   A = T2*C - B + 3.24603288D-5
C08   B = T2*A - C - 4.60626166D-4
C08   C = T2*B - A + 4.81918007D-3
C08   A = T2*C - B - 3.48937694D-2
C08   B = T2*A - C + 1.58067102D-1
C08   C = T2*B - A - 3.70094994D-1
C08   A = T2*C - B + 2.65178613D-1
C08   B = T2*A - C - 8.72344235D-3
C08   Y = T*B - A + 1.57727971D-1
C
C     EXPANSION (0027) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   A = +7.848696314D-11
C09   B = T2*A - 2.679253531D-9
C09   C = T2*B - A + 7.608163592D-8
C09   A = T2*C - B - 1.761946908D-6
C09   B = T2*A - C + 3.246032882D-5
C09   C = T2*B - A - 4.606261662D-4
C09   A = T2*C - B + 4.819180069D-3
C09   B = T2*A - C - 3.489376941D-2
C09   C = T2*B - A + 1.580671023D-1
C09   A = T2*C - B - 3.700949939D-1
C09   B = T2*A - C + 2.651786132D-1
C09   C = T2*B - A - 8.723442353D-3
C09   Y = T*C - B + 1.577279715D-1
C
C     EXPANSION (0027) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   A = +4.125321000000D-14
C12   B = T2*A - 1.943834690000D-12
C12   C = T2*B - A + 7.848696314000D-11
C12   A = T2*C - B - 2.679253530560D-9
C12   B = T2*A - C + 7.608163592419D-8
C12   C = T2*B - A - 1.761946907762D-6
C12   A = T2*C - B + 3.246032882101D-5
C12   B = T2*A - C - 4.606261662063D-4
C12   C = T2*B - A + 4.819180069468D-3
C12   A = T2*C - B - 3.489376941141D-2
C12   B = T2*A - C + 1.580671023321D-1
C12   C = T2*B - A - 3.700949938726D-1
C12   A = T2*C - B + 2.651786132033D-1
C12   B = T2*A - C - 8.723442352852D-3
C12   Y = T*B - A + 1.577279714749D-1
C
C     EXPANSION (0027) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   A = -7.588500000000000D-16
C15   B = T2*A + 4.125321000000000D-14
C15   C = T2*B - A - 1.943834690000000D-12
C15   A = T2*C - B + 7.848696314000000D-11
C15   B = T2*A - C - 2.679253530560000D-9
C15   C = T2*B - A + 7.608163592419000D-8
C15   A = T2*C - B - 1.761946907762150D-6
C15   B = T2*A - C + 3.246032882100508D-5
C15   C = T2*B - A - 4.606261662062751D-4
C15   A = T2*C - B + 4.819180069467605D-3
C15   B = T2*A - C - 3.489376941140889D-2
C15   C = T2*B - A + 1.580671023320973D-1
C15   A = T2*C - B - 3.700949938726498D-1
C15   B = T2*A - C + 2.651786132033368D-1
C15   C = T2*B - A - 8.723442352852221D-3
C15   Y = T*C - B + 1.577279714748901D-1
C
C     EXPANSION (0027) EVALUATED AS Y(T)  --PRECISION 17E.18
      A = +1.22200000000000000D-17
      B = T2*A - 7.58850000000000000D-16
      C = T2*B - A + 4.12532100000000000D-14
      A = T2*C - B - 1.94383469000000000D-12
      B = T2*A - C + 7.84869631400000000D-11
      C = T2*B - A - 2.67925353056000000D-9
      A = T2*C - B + 7.60816359241900000D-8
      B = T2*A - C - 1.76194690776215000D-6
      C = T2*B - A + 3.24603288210050800D-5
      A = T2*C - B - 4.60626166206275050D-4
      B = T2*A - C + 4.81918006946760450D-3
      C = T2*B - A - 3.48937694114088852D-2
      A = T2*C - B + 1.58067102332097261D-1
      B = T2*A - C - 3.70094993872649779D-1
      C = T2*B - A + 2.65178613203336810D-1
      A = T2*C - B - 8.72344235285222129D-3
      Y = T*A - C + 1.57727971474890120D-1
C
C     EXPANSION (0027) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   A = -1.7000000000000000000D-19
C19   B = T2*A + 1.2220000000000000000D-17
C19   C = T2*B - A - 7.5885000000000000000D-16
C19   A = T2*C - B + 4.1253210000000000000D-14
C19   B = T2*A - C - 1.9438346900000000000D-12
C19   C = T2*B - A + 7.8486963140000000000D-11
C19   A = T2*C - B - 2.6792535305600000000D-9
C19   B = T2*A - C + 7.6081635924190000000D-8
C19   C = T2*B - A - 1.7619469077621500000D-6
C19   A = T2*C - B + 3.2460328821005080000D-5
C19   B = T2*A - C - 4.6062616620627505000D-4
C19   C = T2*B - A + 4.8191800694676045000D-3
C19   A = T2*C - B - 3.4893769411408885160D-2
C19   B = T2*A - C + 1.5806710233209726128D-1
C19   C = T2*B - A - 3.7009499387264977903D-1
C19   A = T2*C - B + 2.6517861320333680987D-1
C19   B = T2*A - C - 8.7234423528522212900D-3
C19   Y = T*B - A + 1.5772797147489011957D-1
C
      S17AEF = Y
      GO TO 80
C
C     LARGE X
   40 G = T - 0.5D0/TBPI
      Y = SQRT(TBPI/T)
      CX = COS(G)*Y
      SX = -SIN(G)*Y*8.0D0/T
      T = 128.0D0/(T*T) - 1.0D0
C
C      * EXPANSION (0029) *
C
C     EXPANSION (0029) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   Y = ((((+1.30451717D-8)*T-2.06823782D-7)*T+6.13732440D-6)
C08  *    *T-5.36366929D-4)*T + 9.99457276D-1
C
C     EXPANSION (0029) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   Y = ((((+1.304517171D-8)*T-2.068237815D-7)*T+6.137324403D-6)
C09  *    *T-5.363669290D-4)*T + 9.994572758D-1
C
C     EXPANSION (0029) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   Y = (((((((-2.754930496000D-11)*T+1.653843964800D-10)
C12  *    *T-1.210043336640D-9)*T+1.279709511344D-8)
C12  *    *T-2.052750688707D-7)*T+6.137417432054D-6)
C12  *    *T-5.363673191684D-4)*T + 9.994572757882D-1
C
C     EXPANSION (0029) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   Y = (((((((((((-1.025228800000000D-13)*T+3.455027200000000D-13)
C15  *    *T-1.015733760000000D-12)*T+4.674286080000000D-12)
C15  *    *T-2.491148160000000D-11)*T+1.550640979200000D-10)
C15  *    *T-1.212109809760000D-9)*T+1.280374774304000D-8)
C15  *    *T-2.052744826134800D-7)*T+6.137416081283580D-6)
C15  *    *T-5.363673192129671D-4)*T + 9.994572757882519D-1
C
C     EXPANSION (0029) EVALUATED AS Y(T)  --PRECISION 17E.18
      Y = (((((((((((((-1.17964800000000000D-14)
     *    *T+3.34028800000000000D-14)*T-6.41843200000000000D-14)
     *    *T+2.45294080000000000D-13)*T-1.06365696000000000D-12)
     *    *T+4.78702080000000000D-12)*T-2.48827276800000000D-11)
     *    *T+1.55005642880000000D-10)*T-1.21211819632000000D-9)
     *    *T+1.28037614434400000D-8)*T-2.05274481565160000D-7)
     *    *T+6.13741608010926000D-6)*T-5.36367319213004570D-4)*T +
     *    9.99457275788251954D-1
C
C     EXPANSION (0029) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   Y = (((((((((((((((((-6.5536000000000000000D-16)
C19  *    *T+6.5536000000000000000D-16)*T+9.8304000000000000000D-16)
C19  *    *T+1.8841600000000000000D-15)*T-9.9123200000000000000D-15)
C19  *    *T+2.1893120000000000000D-14)*T-6.9795840000000000000D-14)
C19  *    *T+2.6337280000000000000D-13)*T-1.0583065600000000000D-12)
C19  *    *T+4.7739264000000000000D-12)*T-2.4885177600000000000D-11)
C19  *    *T+1.5501038720000000000D-10)*T-1.2121176452800000000D-9)
C19  *    *T+1.2803760634800000000D-8)*T-2.0527448161860000000D-7)
C19  *    *T+6.1374160801606000000D-6)*T-5.3636731921300309000D-4)*T +
C19  *    9.9945727578825195396D-1
C
C      * EXPANSION (0030) *
C
C     EXPANSION (0030) EVALUATED AS G(T)  --PRECISION 08E.09
C08   G = (((((+6.75219505D-10)*T-5.81753275D-9)*T+7.10458046D-8)
C08  *    *T-1.47708215D-6)*T+6.83314931D-5)*T - 1.55551139D-2
C
C     EXPANSION (0030) EVALUATED AS G(T)  --PRECISION 09E.10
C09   G = ((((((-1.026159174D-10)*T+6.752195048D-10)*T-5.663608873D-9)
C09  *    *T+7.104580461D-8)*T-1.477139871D-6)*T+6.833149306D-5)*T -
C09  *     1.555511388D-2
C
C     EXPANSION (0030) EVALUATED AS G(T)  --PRECISION 12E.13
C12   G = (((((((((+1.089338880000D-12)*T-4.270499840000D-12)
C12  *    *T+1.678831616000D-11)*T-9.407491776000D-11)
C12  *    *T+6.433889390400D-10)*T-5.668946998160D-9)
C12  *    *T+7.106212839584D-8)*T-1.477138803291D-6)
C12  *    *T+6.833149099446D-5)*T - 1.555511387951D-2
C
C     EXPANSION (0030) EVALUATED AS G(T)  --PRECISION 15E.16
C15   G = (((((((((((((+1.273856000000000D-14)*T-3.418112000000000D-14)
C15  *    *T+5.753856000000000D-14)*T-2.097715200000000D-13)
C15  *    *T+8.690073600000000D-13)*T-3.605073920000000D-12)
C15  *    *T+1.702934784000000D-11)*T-9.469828960000000D-11)
C15  *    *T+6.432789595200000D-10)*T-5.668717021760000D-9)
C15  *    *T+7.106214852020000D-8)*T-1.477138832589020D-6)
C15  *    *T+6.833149099344095D-5)*T - 1.555511387951352D-2
C
C     EXPANSION (0030) EVALUATED AS G(T)  --PRECISION 17E.18
      G = ((((((((((((((((-9.83040000000000000D-16)
     *    *T+2.12992000000000000D-15)*T-1.14688000000000000D-15)
     *    *T+4.75136000000000000D-15)*T-2.27942400000000000D-14)
     *    *T+6.95193600000000000D-14)*T-2.28807680000000000D-13)
     *    *T+8.59855360000000000D-13)*T-3.59094272000000000D-12)
     *    *T+1.70330918400000000D-11)*T-9.47034774400000000D-11)
     *    *T+6.43278173280000000D-10)*T-5.66871613024000000D-9)
     *    *T+7.10621485930000000D-8)*T-1.47713883264594000D-6)
     *    *T+6.83314909934390000D-5)*T - 1.55551138795135187D-2
C
C     EXPANSION (0030) EVALUATED AS G(T)  --PRECISION 19E.20
C19   G = ((((((((((((((((+6.5536000000000000000D-16
C19  *    *T-9.8304000000000000000D-16)*T-6.5536000000000000000D-16)
C19  *    *T-1.1468800000000000000D-15)*T+9.6256000000000000000D-15)
C19  *    *T-2.2794240000000000000D-14)*T+6.4993280000000000000D-14)
C19  *    *T-2.2880768000000000000D-13)*T+8.6224896000000000000D-13)
C19  *    *T-3.5909427200000000000D-12)*T+1.7032373760000000000D-11)
C19  *    *T-9.4703477440000000000D-11)*T+6.4327828752000000000D-10)
C19  *    *T-5.6687161302400000000D-9)*T+7.1062148584840000000D-8)
C19  *    *T-1.4771388326459400000D-6)*T+6.8331490993439170000D-5)*T -
C19  *     1.5555113879513518700D-2
C
      S17AEF = Y*CX + G*SX
      GO TO 80
C
C     ERROR 1 EXIT
   60 IFAIL = P01ABF(IFAIL,1,SRNAME,0,P01REC)
      S17AEF = SQRT(TBPI/T)
C
   80 RETURN
      END
