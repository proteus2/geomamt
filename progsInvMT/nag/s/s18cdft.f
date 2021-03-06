      DOUBLE PRECISION FUNCTION S18CDF(X,IFAIL)
C     MARK 10 RELEASE. NAG COPYRIGHT 1982.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     SCALED BESSEL FUNCTION K1(X)EXP(X)
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
C     ALSO INSERT APPROPRIATE DATA STATEMENTS TO DEFINE CONSTANTS
C     WHICH DEPEND ON THE RANGE OF NUMBERS REPRESENTED BY THE
C     MACHINE, RATHER THAN THE PRECISION (SUITABLE STATEMENTS FOR
C     SOME MACHINES ARE CONTAINED IN COMMENTS BEGINNING CRD WHERE
C     D IS A DIGIT WHICH SIMPLY DISTINGUISHES A GROUP OF MACHINES).
C     DELETE THE ILLEGAL DUMMY DATA STATEMENTS WITH VALUES WRITTEN
C     *VALUE*
C
C     **************************************************************
C
C     .. Parameters ..
      CHARACTER*6                      SRNAME
      PARAMETER                        (SRNAME='S18CDF')
C     .. Scalar Arguments ..
      DOUBLE PRECISION                 X
      INTEGER                          IFAIL
C     .. Local Scalars ..
      DOUBLE PRECISION                 G, RYBIG, T, XBIG, XSEST, XSMALL,
     *                                 Y
C     .. Local Arrays ..
      CHARACTER*1                      P01REC(1)
C     .. External Functions ..
      INTEGER                          P01ABF
      EXTERNAL                         P01ABF
C     .. Intrinsic Functions ..
      INTRINSIC                        LOG, EXP, SQRT
C     .. Data statements ..
C08   DATA XBIG, XSMALL /1.0D+10,7.7D-5/
C08   DATA RYBIG /7.97884561D-1/
C09   DATA XBIG, XSMALL /1.0D+11,2.5D-5/
C09   DATA RYBIG /7.978845608D-1/
C12   DATA XBIG, XSMALL /1.0D+14,3.4D-7/
C12   DATA RYBIG /7.978845608029D-1/
C15   DATA XBIG, XSMALL /1.0D+17,1.3D-8/
C15   DATA RYBIG /7.978845608028654D-1/
      DATA XBIG, XSMALL /1.0D+19,7.9D-10/
      DATA RYBIG /7.97884560802865356D-1/
C19   DATA XBIG, XSMALL /1.0D+21,2.7D-10/
C19   DATA RYBIG /7.978845608028653559D-1/
C
C     XBIG IS CHOSEN SUCH THAT
C     IF(X.GE.XBIG) S18CDF = SQRT(PI/2X)
C     TO WITHIN MACHINE ACCURACY
C
C     XSMALL IS CHOSEN SUCH THAT
C     IF(X.LE.XSMALL) S18CDF = 1.0/X
C     TO WITHIN MACHINE ACCURACY
C
      DATA XSEST / 2.23D-308 /
C     XSEST = 1.0/MAXREAL  (ROUNDED UP)
C     FOR IEEE SINGLE PRECISION
CR0   DATA XSEST /1.176E-38/
C     FOR IBM 360/370 AND SIMILAR MACHINES
CR1   DATA XSEST /1.4D-76/
C     FOR DEC-10, HONEYWELL, UNIVAC 1100(S.P.)
CR2   DATA XSEST /5.9D-39/
C     FOR ICL 1900
CR3   DATA XSEST /1.8D-77/
C     FOR CDC 7600/CYBER
CR4   DATA XSEST /0.0D0/
C     FOR UNIVAC 1100(D.P.)
CR5   DATA XSEST /1.2D-308/
C     FOR IEEE DOUBLE PRECISION
CR7   DATA XSEST /2.225D-308/
C     .. Executable Statements ..
C
C     ERROR 1 TEST
      IF (X.LE.0.0D0) GO TO 120
C     ERROR 2 TEST
      IF (X.LE.XSEST) GO TO 140
      IFAIL = 0
C     TEST FOR VERY LARGE X
      IF (X.LT.XBIG) GO TO 20
      S18CDF = 1.0D0/(SQRT(X)*RYBIG)
      GO TO 160
C
C     X RANGE TEST
   20 IF (X.GT.4.0D0) GO TO 100
C     TESTS FOR MIDDLE RANGES
      IF (X.GT.2.0D0) GO TO 80
      IF (X.GT.1.0D0) GO TO 60
C     SMALL X
C     TEST FOR VERY SMALL X
      IF (X.GT.XSMALL) GO TO 40
      S18CDF = 1.0D0/X
      GO TO 160
   40 T = 2.0D0*X*X - 1.0D0
C
C      * EXPANSION (0046) *
C
C     EXPANSION (0046) EVALUATED AS G(T)  --PRECISION 08E.09
C08   G = ((((+4.32772832D-8)*T+6.95322748D-6)*T+6.71642806D-4)
C08  *    *T+3.25725988D-2)*T + 5.31907866D-1
C
C     EXPANSION (0046) EVALUATED AS G(T)  --PRECISION 09E.10
C09   G = ((((+4.327728320D-8)*T+6.953227478D-6)*T+6.716428056D-4)
C09  *    *T+3.257259876D-2)*T + 5.319078659D-1
C
C     EXPANSION (0046) EVALUATED AS G(T)  --PRECISION 12E.13
C12   G = (((((+1.797868742670D-10)*T+4.327728319670D-8)
C12  *    *T+6.953002744441D-6)*T+6.716428055732D-4)
C12  *    *T+3.257259881371D-2)*T + 5.319078659134D-1
C
C     EXPANSION (0046) EVALUATED AS G(T)  --PRECISION 15E.16
C15   G = ((((((+5.338882686656589D-13)*T+1.797868742669985D-10)
C15  *    *T+4.327648236429978D-8)*T+6.953002744441119D-6)
C15  *    *T+6.716428058734987D-4)*T+3.257259881371118D-2)*T +
C15  *    5.319078659133528D-1
C
C     EXPANSION (0046) EVALUATED AS G(T)  --PRECISION 17E.18
      G = (((((((+1.18964962439910400D-15)*T+5.33888268665658944D-13)
     *    *T+1.79784792380155752D-10)*T+4.32764823642997753D-8)
     *    *T+6.95300274548206237D-6)*T+6.71642805873498653D-4)
     *    *T+3.25725988137110495D-2)*T + 5.31907865913352762D-1
C
C     EXPANSION (0046) EVALUATED AS G(T)  --PRECISION 19E.20
C19   G = ((((((((+2.0624995522560000000D-18)
C19  *    *T+1.1896496243991040000D-15)*T+5.3388414366655443200D-13)
C19  *    *T+1.7978479238015575157D-10)*T+4.3276482366877899738D-8)
C19  *    *T+6.9530027454820623725D-6)*T+6.7164280587349813713D-4)
C19  *    *T+3.2572598813711049512D-2)*T + 5.3190786591335276238D-1
C
C      * EXPANSION (0047) *
C
C     EXPANSION (0047) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   Y = ((((+9.96707827D-8)*T+1.44618018D-5)*T+1.20333586D-3)
C08  *    *T+4.50490442D-2)*T + 3.51825828D-1
C
C     EXPANSION (0047) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   Y = ((((+9.967078268D-8)*T+1.446180179D-5)*T+1.203335856D-3)
C09  *    *T+4.504904416D-2)*T + 3.518258283D-1
C
C     EXPANSION (0047) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   Y = ((((((+1.409171030245D-12)*T+4.468344013541D-10)
C12  *    *T+9.966866892738D-8)*T+1.446124325041D-5)
C12  *    *T+1.203335856582D-3)*T+4.504904429669D-2)*T +
C12  *    3.518258282893D-1
C
C     EXPANSION (0047) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   Y = (((((((+3.298810580198656D-15)*T+1.409171030245143D-12)
C15  *    *T+4.468286284356187D-10)*T+9.966866892737815D-8)
C15  *    *T+1.446124325330061D-5)*T+1.203335856582190D-3)
C15  *    *T+4.504904429669437D-2)*T + 3.518258282893255D-1
C
C     EXPANSION (0047) EVALUATED AS Y(T)  --PRECISION 17E.18
      Y = (((((((+3.29881058019865600D-15)*T+1.40917103024514301D-12)
     *    *T+4.46828628435618679D-10)*T+9.96686689273781531D-8)
     *    *T+1.44612432533006139D-5)*T+1.20333585658219028D-3)
     *    *T+4.50490442966943726D-2)*T + 3.51825828289325536D-1
C
C     EXPANSION (0047) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   Y = ((((((((+5.9619895688960000000D-18)
C19  *    *T+3.2988105801986560000D-15)*T+1.4091591062660052160D-12)
C19  *    *T+4.4682862843561867901D-10)*T+9.9668668934830640068D-8)
C19  *    *T+1.4461243253300613892D-5)*T+1.2033358565821887918D-3)
C19  *    *T+4.5049044296694372568D-2)*T + 3.5182582828932553614D-1
C
C
      S18CDF = ((LOG(X)*G-Y)*X+1.0D0/X)*EXP(X)
      GO TO 160
C
C     LOWER MIDDLE X
   60 T = 2.0D0*X - 3.0D0
C
C      * EXPANSION (0048) *
C
C     EXPANSION (0048) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   Y = (((((((((((-5.53041294D-6)*T+1.61377393D-5)*T-3.19000516D-5)
C08  *    *T+9.72531943D-5)*T-3.11466956D-4)*T+9.37672055D-4)
C08  *    *T-2.82407249D-3)*T+8.57314390D-3)*T-2.62546371D-2)
C08  *    *T+8.20250862D-2)*T-2.71910712D-1)*T + 1.24316587D+0
C
C     EXPANSION (0048) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   Y = (((((((((((((-6.500148537D-7)*T+1.895813055D-6)
C09  *    *T-3.417864669D-6)*T+1.045030010D-5)*T-3.454073693D-5)
C09  *    *T+1.036515634D-4)*T-3.098825443D-4)*T+9.343543819D-4)
C09  *    *T-2.824534608D-3)*T+8.573921482D-3)*T-2.625457937D-2)
C09  *    *T+8.202501952D-2)*T-2.719107145D-1)*T + 1.243165874D+0
C
C     EXPANSION (0048) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   Y = ((((((((((((((((-8.994268501852D-9*T+2.622100700789D-8)
C12  *    *T-3.822197877738D-8)*T+1.180200956470D-7)
C12  *    *T-4.302311510204D-7)*T+1.286085167225D-6)
C12  *    *T-3.785765863846D-6)*T+1.137881065569D-5)
C12  *    *T-3.424510122109D-5)*T+1.029877602710D-4)
C12  *    *T-3.100070698581D-4)*T+9.345931657963D-4)
C12  *    *T-2.824507955660D-3)*T+8.573880967991D-3)
C12  *    *T-2.625458186852D-2)*T+8.202502208239D-2)
C12  *    *T-2.719107143888D-1)*T + 1.243165873553D+0
C
C     EXPANSION (0048) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   Y = (((((((((((((((-1.245766994378977D-10
C15  *    *T+3.631164057627682D-10)*T-4.044174349609067D-10)
C15  *    *T+1.269786907006601D-9)*T-5.438216505664956D-9)
C15  *    *T+1.619495860792964D-8)*T-4.642412888983107D-8)
C15  *    *T+1.395139409709952D-7)*T-4.206639303630013D-7)
C15  *    *T+1.262990026862309D-6)*T-3.792217043672815D-6)
C15  *    *T+1.139290202403748D-5)*T-3.424250593971932D-5)
C15  *    *T+1.029827713206788D-4)*T-3.100076788058479D-4)
C15  *    *T+9.345941513100657D-4)*T-2.824507878600541D-3
C15   Y = ((((Y*T+8.573880870871381D-3)*T-2.625458187293567D-2)
C15  *    *T+8.202502208606446D-2)*T-2.719107143886895D-1)*T +
C15  *    1.243165873552553D+0
C
C     EXPANSION (0048) EVALUATED AS Y(T)  --PRECISION 17E.18
      Y = (((((((((((((((-1.46639291782948454D-11
     *    *T+4.27404330568767242D-11)*T-4.02591066627023831D-11)
     *    *T+1.28044023949946257D-10)*T-6.15211416898895086D-10)
     *    *T+1.82808381381205361D-9)*T-5.13783508140332214D-9)
     *    *T+1.54456653909012693D-8)*T-4.66928912168020101D-8)
     *    *T+1.40138351985185509D-7)*T-4.20507152338934956D-7)
     *    *T+1.26265578331941923D-6)*T-3.79227698821142908D-6)
     *    *T+1.13930169202553526D-5)*T-3.42424912211942134D-5)
     *    *T+1.02982746700060730D-4)*T-3.10007681013626626D-4
      Y = ((((((Y*T+9.34594154387642940D-4)*T-2.82450787841655951D-3)
     *    *T+8.57388087067410089D-3)*T-2.62545818729427417D-2)
     *    *T+8.20250220860693888D-2)*T-2.71910714388689413D-1)*T +
     *    1.24316587355255299D+0
C
C     EXPANSION (0048) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   Y = (((((((((((((((+5.9228048741892096000D-13
C19  *    *T-1.7262181759949209600D-12)*T+1.1813547027474677760D-12)
C19  *    *T-3.8750655783265894400D-12)*T+2.3621607439695085568D-11)
C19  *    *T-6.9928481562615087104D-11)*T+1.8875780142065778688D-10)
C19  *    *T-5.6801013864903396557D-10)*T+1.7285943738051638067D-9)
C19  *    *T-5.1858792396219307786D-9)*T+1.5545355974853668307D-8)
C19  *    *T-4.6660221189213356261D-8)*T+1.4007347211871207339D-7)
C19  *    *T-4.2052219774637709952D-7)*T+1.2626836939599514860D-6)
C19  *    *T-3.7922723312996017548D-6)*T+1.1393009060324962970D-5
C19   Y = (((((((((Y*T-3.4242492162849178445D-5)
C19  *    *T+1.0298274809809603393D-4)
C19  *    *T-3.1000768089591975537D-4)*T+9.3459415424130033462D-4)
C19  *    *T-2.8245078784247989861D-3)*T+8.5738808706820003342D-3)
C19  *    *T-2.6254581872942474145D-2)*T+8.2025022086069222005D-2)
C19  *    *T-2.7191071438868941582D-1)*T + 1.2431658735525529948D+0
C
C
      S18CDF = Y
      GO TO 160
C
C     UPPER MIDDLE X
   80 T = X - 3.0D0
C
C      * EXPANSION (0049) *
C
C     EXPANSION (0049) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   Y = (((((((((((-2.80767188D-6)*T+8.21232819D-6)*T-1.63235942D-5)
C08  *    *T+4.99672158D-5)*T-1.60733256D-4)*T+4.87267077D-4)
C08  *    *T-1.48163443D-3)*T+4.55828403D-3)*T-1.42363416D-2)
C08  *    *T+4.58591853D-2)*T-1.60052610D-1)*T + 8.06563480D-1
C
C     EXPANSION (0049) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   Y = (((((((((((((-3.288378470D-7)*T+9.606043659D-7)
C09  *    *T-1.738948881D-6)*T+5.330515096D-6)*T-1.765949795D-5)
C09  *    *T+5.320925552D-5)*T-1.599317140D-4)*T+4.855860198D-4)
C09  *    *T-1.481868211D-3)*T+4.558678032D-3)*T-1.423631240D-2)
C09  *    *T+4.585915154D-2)*T-1.600526113D-1)*T + 8.065634801D-1
C
C     EXPANSION (0049) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   Y = ((((((((((((((((-4.531129487461D-9*T+1.322027909574D-8)
C12  *    *T-1.932294815225D-8)*T+5.973540672953D-8)
C12  *    *T-2.178621908264D-7)*T+6.523783491198D-7)
C12  *    *T-1.924669665692D-6)*T+5.799770578267D-6)
C12  *    *T-1.751027268491D-5)*T+5.287381608171D-5)
C12  *    *T-1.599945661164D-4)*T+4.857066770628D-4)
C12  *    *T-1.481854759192D-3)*T+4.558657561062D-3)
C12  *    *T-1.423631366621D-2)*T+4.585915283955D-2)
C12  *    *T-1.600526112914D-1)*T + 8.065634801288D-1
C
C     EXPANSION (0049) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   Y = (((((((((((((((+1.825965554404127D-10
C15  *    *T-5.325302338595793D-10)*T+6.402818048272803D-10)
C15  *    *T-2.001610876627515D-9)*T+8.170676878159389D-9)
C15  *    *T-2.438198537392036D-8)*T+7.055861969739777D-8)
C15  *    *T-2.123288688651719D-7)*T+6.407497448872547D-7)
C15  *    *T-1.928266324966377D-6)*T+5.806865392193329D-6)
C15  *    *T-1.750885971161883D-5)*T+5.287130428221953D-5)
C15  *    *T-1.599948921871346D-4)*T+4.857071732324254D-4)
C15  *    *T-1.481854718432934D-3)*T+4.558657512166365D-3
C15   Y = (((Y*T-1.423631366853077D-2)*T+4.585915284139983D-2)
C15  *    *T-1.600526112913260D-1)*T + 8.065634801287869D-1
C
C     EXPANSION (0049) EVALUATED AS Y(T)  --PRECISION 17E.18
      Y = (((((((((((((((-7.36478297050421658D-12
     *    *T+2.14736751065133220D-11)*T-2.02680401514735862D-11)
     *    *T+6.44913423545894175D-11)*T-3.09667392343245062D-10)
     *    *T+9.20781685906110546D-10)*T-2.59039399308009059D-9)
     *    *T+7.79421651144832709D-9)*T-2.35855618461025265D-8)
     *    *T+7.08723366696569880D-8)*T-2.12969229346310343D-7)
     *    *T+6.40581814037398274D-7)*T-1.92794586996432593D-6)
     *    *T+5.80692311842296724D-6)*T-1.75089594354079944D-5)
     *    *T+5.28712919123131781D-5)*T-1.59994873621599146D-4
      Y = ((((((Y*T+4.85707174778663652D-4)*T-1.48185472032688523D-3)
     *    *T+4.55865751206724687D-3)*T-1.42363136684423646D-2)
     *    *T+4.58591528414023064D-2)*T-1.60052611291327173D-1)*T +
     *    8.06563480128786903D-1
C
C     EXPANSION (0049) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   Y = (((((((((((((((+2.9720563474130534400D-13
C19  *    *T-8.6644010086144409600D-13)*T+5.9419353180379545600D-13)
C19  *    *T-1.9495323401201909760D-12)*T+1.1871524460007784448D-11)
C19  *    *T-3.5159979385029656576D-11)*T+9.4979353575388872704D-11)
C19  *    *T-2.8597567083531495014D-10)*T+8.7082496463265398784D-10)
C19  *    *T-2.6145087810435194552D-9)*T+7.8442727210030060995D-9)
C19  *    *T-2.3569163790287394865D-8)*T+7.0839760076322691277D-8)
C19  *    *T-2.1297678108254099543D-7)*T+6.4059582796994949383D-7)
C19  *    *T-1.9279435325221593010D-6)*T+5.8069191719880813601D-6
C19   Y = (((((((((Y*T-1.7508959908052550159D-5)
C19  *    *T+5.2871292614255405548D-5)
C19  *    *T-1.5999487356251857636D-4)*T+4.8570717470518661195D-4)
C19  *    *T-1.4818547203310208658D-3)*T+4.5586575120712130814D-3)
C19  *    *T-1.4236313668442230356D-2)*T+4.5859152841402222640D-2)
C19  *    *T-1.6005261129132717388D-1)*T + 8.0656348012878690333D-1
C
C
      S18CDF = Y
      GO TO 160
C
C     LARGE X
  100 T = 10.0D0/(1.0D0+X) - 1.0D0
C
C      * EXPANSION (0050) *
C
C     EXPANSION (0050) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   Y = ((((((+4.15227791D-7)*T+4.41450005D-6)*T+4.04672723D-5)
C08  *    *T+4.29930337D-4)*T+4.31639530D-3)*T+5.44845309D-2)*T +
C08  *    1.30387574D+0
C
C     EXPANSION (0050) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   Y = (((((((+5.025365409D-8)*T+4.152277906D-7)*T+4.326556158D-6)
C09  *    *T+4.046727232D-5)*T+4.299743088D-4)*T+4.316395301D-3)
C09  *    *T+5.448452541D-2)*T + 1.303875736D+0
C
C     EXPANSION (0050) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   Y = (((((((((+7.301703878977D-10)*T+3.832259940424D-9)
C12  *    *T+4.861077072000D-8)*T+4.075632707351D-7)
C12  *    *T+4.327788320346D-6)*T+4.047206264256D-5)
C12  *    *T+4.299739665252D-4)*T+4.316394342954D-3)
C12  *    *T+5.448452543211D-2)*T + 1.303875736042D+0
C
C     EXPANSION (0050) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   Y = (((((((((((((+1.380665734740812D-12)*T-3.733637564332706D-12)
C15  *    *T+1.641892841205222D-11)*T+8.683117058706912D-12)
C15  *    *T+6.782875893077243D-10)*T+3.825953402729925D-9)
C15  *    *T+4.866489710040398D-8)*T+4.075642969229087D-7)
C15  *    *T+4.327764149271439D-6)*T+4.047206307821104D-5)
C15  *    *T+4.299739708940049D-4)*T+4.316394342839177D-3)
C15  *    *T+5.448452543189329D-2)*T + 1.303875736042304D+0
C
C     EXPANSION (0050) EVALUATED AS Y(T)  --PRECISION 17E.18
      Y = ((((((((((((((((-4.77850238111580160D-14)
     *    *T+1.39321122940600320D-13)*T-2.19287104441802752D-13)
     *    *T+8.58211523713560576D-13)*T-2.60774502020271104D-12)
     *    *T+1.72026097285930936D-11)*T+6.97075379117731379D-12)
     *    *T+6.77688943857588882D-10)*T+3.82717692121438315D-9)
     *    *T+4.86651420008153956D-8)*T+4.07563856931843484D-7)
     *    *T+4.32776409784235211D-6)*T+4.04720631528495020D-5)
     *    *T+4.29973970898766831D-4)*T+4.31639434283445364D-3)
     *    *T+5.44845254318931612D-2)*T + 1.30387573604230402D+0
C
C     EXPANSION (0050) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   Y = (((((((((((((((-6.3620245490237440000D-15
C19  *    *T+1.7167080100134912000D-14)*T-1.9155913340551168000D-14)
C19  *    *T+6.6361032515026944000D-14)*T-2.7296668657419059200D-13)
C19  *    *T+9.8589168195831398400D-13)*T-2.5534689982688522240D-12)
C19  *    *T+1.7084049581651536896D-11)*T+6.9387697068234327040D-12)
C19  *    *T+6.7775164393529835878D-10)*T+3.8271879926281979580D-9)
C19  *    *T+4.8665123190792082758D-8)*T+4.0756385477906857561D-7)
C19  *    *T+4.3277641008348558223D-6)*T+4.0472063153059187890D-5)
C19  *    *T+4.2997397089855308118D-4)*T+4.3163943428344457734D-3
C19   Y = (Y*T+5.4484525431893165681D-2)*T + 1.3038757360423040162D+0
C
C
      S18CDF = Y/SQRT(X)
      GO TO 160
C
  120 IFAIL = P01ABF(IFAIL,1,SRNAME,0,P01REC)
      S18CDF = 0.0D0
      GO TO 160
C
  140 IFAIL = P01ABF(IFAIL,2,SRNAME,0,P01REC)
      S18CDF = 1.0D0/XSEST
C
  160 RETURN
      END
