      DOUBLE PRECISION FUNCTION S20ACF(X,IFAIL)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978.
C     MARK 11.5(F77) REVISED. (SEPT 1985.)
C     FRESNEL INTEGRAL S(X)
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
C     .. Scalar Arguments ..
      DOUBLE PRECISION                 X
      INTEGER                          IFAIL
C     .. Local Scalars ..
      DOUBLE PRECISION                 A, B, C, F, G, S, T, TBPI, TH, U,
     *                                 XBIG, XSMALL, XVBIG, XVSMAL, Y
      INTEGER                          K, N
C     .. Intrinsic Functions ..
      INTRINSIC                        ABS, MOD, SIGN, COS, DBLE, SIN
C     .. Data statements ..
C08   DATA TBPI,XSMALL,XBIG/
C08  A6.36619772D-1,4.8D-2,1.6D2/
C09   DATA TBPI,XSMALL,XBIG/
C09  A6.366197724D-1,1.4D-2,3.9D2/
C12   DATA TBPI,XSMALL,XBIG/
C12  A6.366197723676D-1,2.5D-3,3.9D3/
C15   DATA TBPI,XSMALL,XBIG/
C15  A6.366197723675813D-1,4.4D-4,5.0D4/
      DATA TBPI,XSMALL,XBIG/
     A6.36619772367581343D-1,1.8D-4,2.6D5/
C19   DATA TBPI,XSMALL,XBIG/
C19  A6.3661977236758134308D-1,5.5D-5,6.2D5/
      DATA XVSMAL / 3.49D-103 /
C     XVSMAL = ((6.0/PI)*MINREAL)**(1.0/3.0)  (ROUNDED UP)
C     FOR IEEE SINGLE PRECISION
CR0   DATA XVSMAL /2.83E-13/
C     FOR IBM 360/370 AND SIMILAR MACHINES
CR1   DATA XVSMAL /1.1D-26/
C     FOR DEC-10, HONEYWELL, UNIVAC 1100(S.P.)
CR2   DATA XVSMAL /1.5D-13/
C     FOR ICL 1900
CR3   DATA XVSMAL /2.1D-26/
C     FOR CDC 7600/CYBER
CR4   DATA XVSMAL /1.82D-96/
C     FOR UNIVAC 1100(D.P.)
CR5   DATA XVSMAL /1.75D-103/
C     FOR IEEE DOUBLE PRECISION
CR7   DATA XVSMAL /3.49D-103/
      DATA XVBIG / 4.29496729D+9 /
C     XVBIG = SMALLEST OF THE FOLLOWING
C     1.)  BASE/(PI*MACHEPS)
C     2.)  2.0*BASE**(T-1),  WHERE T IS NO. OF DIGITS IN MANTISSA
C     3.)  2.0*(MAXINT+1)
C     FOR IBM 360/370 (S.P.)
CR8   DATA XVBIG /2.1D+6/
C     FOR IEEE SINGLE PRECISION
CR0   DATA XVBIG /8.388608E+6/
C     FOR DEC-10, UNIVAC 1100(S.P.)
CR2   DATA XVBIG /8.7D+7/
C     FOR ICL 1900
CR3   DATA XVBIG /1.6777216D+7/
C     FOR CDC 7600/CYBER
CR4   DATA XVBIG /1.8D+14/
C     FOR IBM 360/370 AND SIMILAR MACHINES (D.P.)
CR9   DATA XVBIG /4.294967296D+9/
C     FOR UNIVAC 1100(D.P.)
CR5   DATA XVBIG /6.8719476736D+10/
C     FOR IEEE DOUBLE PRECISION
CR7   DATA XVBIG /4.294967296D+9/
C
C     .. Executable Statements ..
C     NO FAILURE EXITS
      IFAIL = 0
      U = ABS(X)
C      SWITCH ON BASIC RANGE
      IF (U.GT.3.0D0) GO TO 60
C     LOWER RANGE
      IF (U.GE.XSMALL) GO TO 40
      IF (U.GE.XVSMAL) GO TO 20
C     X VERY SMALL - UNDERFLOW REGION
      S20ACF = 0.0D0
      GO TO 300
C
C     X IN LIMITING RANGE
   20 S20ACF = X*X/(3.0D0*TBPI)*X
      GO TO 300
C
C     X IN BASIC LOWER RANGE
   40 T = X/3.0D0
      T = T*T
      T = 2.0D0*T*T - 1.0D0
C
C      * EXPANSION (0052) *
C
C     EXPANSION (0052) EVALUATED AS Y(T)  --PRECISION 08E.09
C08   Y = ((((((((((((((+6.39492767D-6)*T-5.03118359D-5)
C08  *    *T+3.16611738D-4)*T-1.76549525D-3)*T+8.12986510D-3)
C08  *    *T-2.99521169D-2)*T+8.52522455D-2)*T-1.76968509D-1)
C08  *    *T+2.39974031D-1)*T-1.52262948D-1)*T-6.68325797D-2)
C08  *    *T+1.58081431D-1)*T-3.37698367D-2)*T-4.96904567D-2)*T +
C08  *    3.79136372D-2
C
C     EXPANSION (0052) EVALUATED AS Y(T)  --PRECISION 09E.10
C09   Y = (((((((((((((((-7.043869421D-7)*T+6.394927667D-6)
C09  *    *T-4.767038482D-5)*T+3.166117380D-4)*T-1.769457425D-3)
C09  *    *T+8.129865096D-3)*T-2.994909028D-2)*T+8.525224551D-2)
C09  *    *T-1.769697468D-1)*T+2.399740311D-1)*T-1.522626878D-1)
C09  *    *T-6.683257966D-2)*T+1.580814068D-1)*T-3.376983668D-2)
C09  *    *T-4.969045608D-2)*T + 3.791363725D-2
C
C     EXPANSION (0052) EVALUATED AS Y(T)  --PRECISION 12E.13
C12   Y = ((((((((((((((((-5.782679338408D-9*T+6.791706499654D-8)
C12  *    *T-6.798105549073D-7)*T+6.123259406878D-6)
C12  *    *T-4.771339349501D-5)*T+3.170531989182D-4)
C12  *    *T-1.769417488205D-3)*T+8.129491552061D-3)
C12  *    *T-2.994911139614D-2)*T+8.525242060441D-2)
C12  *    *T-1.769697404530D-1)*T+2.399739865160D-1)
C12  *    *T-1.522626887723D-1)*T-6.683257408989D-2)
C12  *    *T+1.580814068419D-1)*T-3.376983694445D-2)
C12  *    *T-4.969045608228D-2)*T + 3.791363724798D-2
C
C     EXPANSION (0052) EVALUATED AS Y(T)  --PRECISION 15E.16
C15   Y = (((((((((((((((-2.973262185715466D-11
C15  *    *T+4.381007790286992D-10)*T-5.641449384586586D-9)
C15  *    *T+6.594561149091315D-8)*T-6.800930148149253D-7)
C15  *    *T+6.126955882201553D-6)*T-4.771308455448955D-5)
C15  *    *T+3.170494613709726D-4)*T-1.769417689016187D-3)
C15  *    *T+8.129493754544652D-3)*T-2.994911131725243D-2)
C15  *    *T+8.525241984200874D-2)*T-1.769697404712263D-1)
C15  *    *T+2.399739866642467D-1)*T-1.522626887700225D-1)
C15  *    *T-6.683257410432746D-2)*T+1.580814068417530D-1
C15   Y = ((Y*T-3.376983694390804D-2)*T-4.969045608227489D-2)*T +
C15  *    3.791363724797823D-2
C
C     EXPANSION (0052) EVALUATED AS Y(T)  --PRECISION 17E.18
      Y = (((((((((((((((+1.81844518417098342D-12
     *    *T-2.97326218571546624D-11)*T+4.29008553107844235D-10)
     *    *T-5.64144938458658596D-9)*T+6.59649324709949702D-8)
     *    *T-6.80093014814925278D-7)*T+6.12693315163675043D-6)
     *    *T-4.77130845544895467D-5)*T+3.17049477530983542D-4)
     *    *T-1.76941768901618713D-3)*T+8.12949374743424699D-3)
     *    *T-2.99491113172524286D-2)*T+8.52524198439133102D-2)
     *    *T-1.76969740471226316D-1)*T+2.39973986663953660D-1)
     *    *T-1.52262688770022483D-1)*T-6.68325741043045694D-2
      Y = (((Y*T+1.58081406841752979D-1)*T-3.37698369439087378D-2)
     *    *T-4.96904560822748930D-2)*T + 3.79136372479782339D-2
C
C     EXPANSION (0052) EVALUATED AS Y(T)  --PRECISION 19E.20
C19   Y = (((((((((((((((+5.0828262170951680000D-15
C19  *    *T-1.0076157208795545600D-13)*T+1.7904896399769600000D-12)
C19  *    *T-2.9203623603692896256D-11)*T+4.2907494752530504090D-10)
C19  *    *T-5.6426396306568749384D-9)*T+6.5964843362697851765D-8)
C19  *    *T-6.8009151598654046924D-7)*T+6.1269332258936646994D-6)
C19  *    *T-4.7713085711673226103D-5)*T+3.1704947749123425303D-4)
C19  *    *T-1.7694176884520600850D-3)*T+8.1294937474479108072D-3)
C19  *    *T-2.9949111317424800757D-2)*T+8.5252419843910382239D-2)
C19  *    *T-1.7696974047119465538D-1)*T+2.3997398666395402607D-1
C19   Y = (((((Y*T-1.5226268877002567989D-1)
C19  *    *T-6.6832574104304592910D-2)
C19  *    *T+1.5808140684175312719D-1)*T-3.3769836943908737232D-2)
C19  *    *T-4.9690456082274895053D-2)*T + 3.7913637247978233924D-2
C
      S20ACF = X*X*X*Y
      GO TO 300
C
C     UPPER RANGE
   60 IF (U.LT.XVBIG) GO TO 80
C     X IN LIMITING LARGE X RANGE
      S20ACF = SIGN(0.5D0,X)
      GO TO 300
C
C     X IN BASIC UPPER RANGE OR SEMI LIMITING RANGE
C     CALC. EFECTIVE ARGUMENT OF SIN AND COS
   80 T = 0.5D0*U
      K = T
      Y = DBLE(K)
      A = T - Y
      T = A*Y
      K = T
      B = T - DBLE(K)
      T = (2.0D0*B+A*A)*4.0D0
      K = T
      TH = ((8.0D0*B-DBLE(K))+4.0D0*A*A)/TBPI
      N = MOD(K,4) + 1
C     CALC. COS
      GO TO (100,120,140,160) N
  100 C = COS(TH)
      GO TO 180
  120 C = -SIN(TH)
      GO TO 180
  140 C = -COS(TH)
      GO TO 180
  160 C = SIN(TH)
C     EVAL. F AND SEMI LIMITING FORM
  180 T = 3.0D0/X
      T = T*T
      T = 2.0D0*T*T - 1.0D0
C
C      * EXPANSION (0053) *
C
C     EXPANSION (0053) EVALUATED AS F(T)  --PRECISION 08E.09
C08   F = (((((-5.93583900D-9)*T+4.72717282D-8)*T-5.42175825D-7)
C08  *    *T+1.10965120D-5)*T-5.73211031D-4)*T + 3.17724983D-1
C
C     EXPANSION (0053) EVALUATED AS F(T)  --PRECISION 09E.10
C09   F = ((((((+9.829047856D-10)*T-5.935838999D-9)*T+4.579737107D-8)
C09  *    *T-5.421758250D-7)*T+1.109706487D-5)*T-5.732110305D-4)*T +
C09  *    3.177249832D-1
C
C     EXPANSION (0053) EVALUATED AS F(T)  --PRECISION 12E.13
C12   F = (((((((((-1.357202069887D-11)*T+4.878102142618D-11)
C12  *    *T-1.707125662642D-10)*T+8.853427427869D-10)
C12  *    *T-5.606554961046D-9)*T+4.585834734726D-8)
C12  *    *T-5.423455565629D-7)*T+1.109705267873D-5)
C12  *    *T-5.732110089693D-4)*T + 3.177249831933D-1
C
C     EXPANSION (0053) EVALUATED AS F(T)  --PRECISION 15E.16
C15   F = (((((((((((((-2.202608491851653D-13)*T+5.462909561870602D-13)
C15  *    *T-7.426524837273958D-13)*T+2.597867258691246D-12)
C15  *    *T-1.045595472884368D-11)*T+4.003290308517780D-11)
C15  *    *T-1.741865561141896D-10)*T+8.936546026418932D-10)
C15  *    *T-5.604956794638033D-9)*T+4.585526145869023D-8)
C15  *    *T-5.423458503385860D-7)*T+1.109705307327023D-5)
C15  *    *T-5.732110089543312D-4)*T + 3.177249831932574D-1
C
C     EXPANSION (0053) EVALUATED AS F(T)  --PRECISION 17E.18
      F = ((((((((((((((((+2.07506727741685760D-14)
     *    *T-4.32090910458347520D-14)*T+1.17703805954293760D-14)
     *    *T-5.82267577632849920D-14)*T+3.49464578296793088D-13)
     *    *T-9.85703620860216320D-13)*T+2.93983396595156736D-12)
     *    *T-1.02702906657561134D-11)*T+3.97754267719339848D-11)
     *    *T-1.74262509594543650D-10)*T+8.93749825962406591D-10)
     *    *T-5.60494084440715823D-9)*T+4.58552450207356043D-8)
     *    *T-5.42345851815459185D-7)*T+1.10970530743229298D-5)
     *    *T-5.73211008954291666D-4)*T + 3.17724983193257364D-1
C
C     EXPANSION (0053) EVALUATED AS F(T)  --PRECISION 19E.20
C19   F = (((((((((((((((+1.6966016198246400000D-15
C19  *    *T-2.9966939295580160000D-15)*T-2.9966396020490240000D-15)
C19  *    *T+3.7898570028154880000D-15)*T+1.4088406747971584000D-14)
C19  *    *T-2.7288816935649280000D-14)*T+3.6854094541684736000D-14)
C19  *    *T-1.0476975117319782400D-13)*T+3.1773621848230502400D-13)
C19  *    *T-9.3381110275379200000D-13)*T+2.9607818488980126720D-12)
C19  *    *T-1.0300486158980194560D-11)*T+3.9767656163120972800D-11)
C19  *    *T-1.7425290047965440480D-10)*T+8.9375140905558722070D-10)
C19  *    *T-5.6049424356830408410D-9)*T+4.5855244861268141885D-8
C19   F = (((F*T-5.4234585169844556520D-7)
C19  *    *T+1.1097053074329063571D-5)
C19  *    *T-5.7321100895429415857D-4)*T + 3.1772498319325736402D-1
C
      S20ACF = SIGN(0.5D0,X) - F*C/X
      IF (U.GT.XBIG) GO TO 300
C
C     BASIC UPPER RANGE
C     EVAL. S AND G , COMPLETE UPPER RANGE FORM
      GO TO (200,220,240,260) N
  200 S = SIN(TH)
      GO TO 280
  220 S = COS(TH)
      GO TO 280
  240 S = -SIN(TH)
      GO TO 280
  260 S = -COS(TH)
  280 CONTINUE
C
C      * EXPANSION (0054) *
C
C     EXPANSION (0054) EVALUATED AS G(T)  --PRECISION 08E.09
C08   G = ((((((+6.24327451D-9)*T-3.29585381D-8)*T+2.12006168D-7)
C08  *    *T-2.00950571D-6)*T+2.97191981D-5)*T-8.84035394D-4)*T +
C08  *    1.00405168D-1
C
C     EXPANSION (0054) EVALUATED AS G(T)  --PRECISION 09E.10
C09   G = (((((((-1.427253493D-9)*T+6.243274506D-9)*T-3.046084452D-8)
C09  *    *T+2.120061684D-7)*T-2.010754562D-6)*T+2.971919810D-5)
C09  *    *T-8.840352376D-4)*T + 1.004051683D-1
C
C     EXPANSION (0054) EVALUATED AS G(T)  --PRECISION 12E.13
C12   G = (((((((((((-1.402758722109D-11)*T+3.829716986454D-11)
C12  *    *T-7.582193245551D-11)*T+2.838631657901D-10)
C12  *    *T-1.208434313657D-9)*T+5.567837384643D-9)
C12  *    *T-3.063701386332D-8)*T+2.124507563370D-7)
C12  *    *T-2.010703951449D-6)*T+2.971910693717D-5)
C12  *    *T-8.840352414821D-4)*T + 1.004051683139D-1
C
C     EXPANSION (0054) EVALUATED AS G(T)  --PRECISION 15E.16
C15   G = ((((((((((((((((+2.521469981689119D-13)
C15  *    *T-5.048511878397133D-13)*T+5.277765106919014D-14)
C15  *    *T-4.624209772280136D-13)*T+3.479134312657932D-12)
C15  *    *T-9.211633124902072D-12)*T+2.535330780212986D-11)
C15  *    *T-8.322232754249400D-11)*T+2.997786114508160D-10)
C15  *    *T-1.203579940865046D-9)*T+5.559169647770702D-9)
C15  *    *T-3.063850219580606D-8)*T+2.124528522698467D-7)
C15  *    *T-2.010703759368367D-6)*T+2.971910675359472D-5)
C15  *    *T-8.840352414891330D-4)*T + 1.004051683139144D-1
C
C     EXPANSION (0054) EVALUATED AS G(T)  --PRECISION 17E.18
      G = (((((((((((((((-4.03463395677306880D-14
     *    *T+7.15411005552721920D-14)*T+6.00164238700707840D-14)
     *    *T-6.97879543298129920D-14)*T-3.28719485157392384D-13)
     *    *T+6.56405687004299264D-13)*T-1.02218566766464614D-12)
     *    *T+2.86879929854576640D-12)*T-8.57506788593757696D-12)
     *    *T+2.57129695068745262D-11)*T-8.35960290000537167D-11)
     *    *T+2.99654113168404345D-10)*T-1.20346041915192622D-9)
     *    *T+5.55919385577005967D-9)*T-3.06385220528144918D-8)
     *    *T+2.12452849911924725D-7)*T-2.01070375790489234D-6
      G = ((G*T+2.97191067536831375D-5)*T-8.84035241489164211D-4)*T
     *    + 1.00405168313914407D-1
C
C     EXPANSION (0054) EVALUATED AS G(T)  --PRECISION 19E.20
C19   G = (((((((((((((((-5.5973482940334080000D-15
C19  *    *T+8.7869648200007680000D-15)*T+1.8010667322703872000D-14)
C19  *    *T-2.4787441302896640000D-14)*T-4.6394273112522752000D-14)
C19  *    *T+6.8616502480994304000D-14)*T+7.2432219213004800000D-15)
C19  *    *T+2.6287261495066624000D-14)*T-2.2046886451014860800D-13)
C19  *    *T+4.9051693608265318400D-13)*T-1.1251226547783802880D-12)
C19  *    *T+3.0092835359540797440D-12)*T-8.5185937341252208640D-12)
C19  *    *T+2.5644542449373548032D-11)*T-8.3614658325737224704D-11)
C19  *    *T+2.9967370727686276813D-10)*T-1.2034568082551629090D-9
C19   G = ((((((G*T+5.5591906952804112065D-9)
C19  *    *T-3.0638522432231969874D-8)
C19  *    *T+2.1245285016771020051D-7)*T-2.0107037578867765040D-6)
C19  *    *T+2.9719106753675171307D-5)*T-8.8403524148916446459D-4)*T +
C19  *    1.0040516831391440676D-1
C
      S20ACF = S20ACF - S*G/(X*X*X)
  300 RETURN
      END
