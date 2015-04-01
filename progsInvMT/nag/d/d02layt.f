      SUBROUTINE D02LAY(A,C,BCAP,BDCAP,B,BD)
C     MARK 13 RELEASE. NAG COPYRIGHT 1988.
C
C     THIS ROUTINE RETURNS THE COEFFICIENTS FOR THE RUNGE-KUTTA
C     NYSTROM 12(10) PAIR OF DORMAND AND PRINCE.  THE COEFFICIENTS
C     WERE SUPPLIED BY D/P.
C     COEFFICIENTS OF RKN12(10)17M TO 30 DECIMAL PLACES FROM MACSYMA.
C
C     .. Array Arguments ..
      DOUBLE PRECISION  A(17,17), B(16), BCAP(15), BD(16), BDCAP(17),
     *                  C(17)
C     .. Executable Statements ..
C
      C(1) = 0.0D0
      C(2) = 2.0D-2
      C(3) = 4.0D-2
      C(4) = 1.0D-1
      C(5) = 1.33333333333333333333333333333D-1
      C(6) = 1.6D-1
      C(7) = 5.0D-2
      C(8) = 2.0D-1
      C(9) = 2.5D-1
      C(10) = 3.33333333333333333333333333333D-1
      C(11) = 5.0D-1
      C(12) = 5.55555555555555555555555555556D-1
      C(13) = 7.5D-1
      C(14) = 8.57142857142857142857142857143D-1
      C(15) = 9.45216222272014340129957427739D-1
      C(16) = 1.0D0
      C(17) = 1.0D0
C
      A(2,1) = 2.0D-4
C
      A(3,1) = 2.66666666666666666666666666667D-4
      A(3,2) = 5.33333333333333333333333333333D-4
C
      A(4,1) = 2.91666666666666666666666666667D-3
      A(4,2) = -4.16666666666666666666666666667D-3
      A(4,3) = 6.25D-3
C
      A(5,1) = 1.64609053497942386831275720165D-3
      A(5,2) = 0.0D0
      A(5,3) = 5.48696844993141289437585733882D-3
      A(5,4) = 1.75582990397805212620027434842D-3
C
      A(6,1) = 1.9456D-3
      A(6,2) = 0.0D0
      A(6,3) = 7.15174603174603174603174603175D-3
      A(6,4) = 2.91271111111111111111111111111D-3
      A(6,5) = 7.89942857142857142857142857143D-4
C
      A(7,1) = 5.6640625D-4
      A(7,2) = 0.0D0
      A(7,3) = 8.80973048941798941798941798942D-4
      A(7,4) = -4.36921296296296296296296296296D-4
      A(7,5) = 3.39006696428571428571428571429D-4
      A(7,6) = -9.94646990740740740740740740741D-5
C
      A(8,1) = 3.08333333333333333333333333333D-3
      A(8,2) = 0.0D0
      A(8,3) = 0.0D0
      A(8,4) = 1.77777777777777777777777777778D-3
      A(8,5) = 2.7D-3
      A(8,6) = 1.57828282828282828282828282828D-3
      A(8,7) = 1.08606060606060606060606060606D-2
C
      A(9,1) = 3.65183937480112971375119150338D-3
      A(9,2) = 0.0D0
      A(9,3) = 3.96517171407234306617557289807D-3
      A(9,4) = 3.19725826293062822350093426091D-3
      A(9,5) = 8.22146730685543536968701883401D-3
      A(9,6) = -1.31309269595723798362013884863D-3
      A(9,7) = 9.77158696806486781562609494147D-3
      A(9,8) = 3.75576906923283379487932641079D-3
C
      A(10,1) = 3.70724106871850081019565530521D-3
      A(10,2) = 0.0D0
      A(10,3) = 5.08204585455528598076108163479D-3
      A(10,4) = 1.17470800217541204473569104943D-3
      A(10,5) = -2.11476299151269914996229766362D-2
      A(10,6) = 6.01046369810788081222573525136D-2
      A(10,7) = 2.01057347685061881846748708777D-2
      A(10,8) = -2.83507501229335808430366774368D-2
      A(10,9) = 1.48795689185819327555905582479D-2
C
      A(11,1) = 3.51253765607334415311308293052D-2
      A(11,2) = 0.0D0
      A(11,3) = -8.61574919513847910340576078545D-3
      A(11,4) = -5.79144805100791652167632252471D-3
      A(11,5) = 1.94555482378261584239438810411D0
      A(11,6) = -3.43512386745651359636787167574D0
      A(11,7) = -1.09307011074752217583892572001D-1
      A(11,8) = 2.3496383118995166394320161088D0
      A(11,9) = -7.56009408687022978027190729778D-1
      A(11,10) = 1.09528972221569264246502018618D-1
C
      A(12,1) = 2.05277925374824966509720571672D-2
      A(12,2) = 0.0D0
      A(12,3) = -7.28644676448017991778247943149D-3
      A(12,4) = -2.11535560796184024069259562549D-3
      A(12,5) = 9.27580796872352224256768033235D-1
      A(12,6) = -1.65228248442573667907302673325D0
      A(12,7) = -2.10795630056865698191914366913D-2
      A(12,8) = 1.20653643262078715447708832536D0
      A(12,9) = -4.13714477001066141324662463645D-1
      A(12,10) = 9.07987398280965375956795739516D-2
      A(12,11) = 5.35555260053398504916870658215D-3
C
      A(13,1) = -1.43240788755455150458921091632D-1
      A(13,2) = 0.0D0
      A(13,3) = 1.25287037730918172778464480231D-2
      A(13,4) = 6.82601916396982712868112411737D-3
      A(13,5) = -4.79955539557438726550216254291D0
      A(13,6) = 5.69862504395194143379169794156D0
      A(13,7) = 7.55343036952364522249444028716D-1
      A(13,8) = -1.27554878582810837175400796542D-1
      A(13,9) = -1.96059260511173843289133255423D0
      A(13,10) = 9.18560905663526240976234285341D-1
      A(13,11) = -2.38800855052844310534827013402D-1
      A(13,12) = 1.59110813572342155138740170963D-1
C
      A(14,1) = 8.04501920552048948697230778134D-1
      A(14,2) = 0.0D0
      A(14,3) = -1.66585270670112451778516268261D-2
      A(14,4) = -2.1415834042629734811731437191D-2
      A(14,5) = 1.68272359289624658702009353564D1
      A(14,6) = -1.11728353571760979267882984241D1
      A(14,7) = -3.37715929722632374148856475521D0
      A(14,8) = -1.52433266553608456461817682939D1
      A(14,9) = 1.71798357382154165620247684026D1
      A(14,10) = -5.43771923982399464535413738556D0
      A(14,11) = 1.38786716183646557551256778839D0
      A(14,12) = -5.92582773265281165347677029181D-1
      A(14,13) = 2.96038731712973527961592794552D-2
C
      A(15,1) = -9.13296766697358082096250482648D-1
      A(15,2) = 0.0D0
      A(15,3) = 2.41127257578051783924489946102D-3
      A(15,4) = 1.76581226938617419820698839226D-2
      A(15,5) = -1.48516497797203838246128557088D1
      A(15,6) = 2.15897086700457560030782161561D0
      A(15,7) = 3.99791558311787990115282754337D0
      A(15,8) = 2.84341518002322318984542514988D1
      A(15,9) = -2.52593643549415984378843352235D1
      A(15,10) = 7.7338785423622373655340014114D0
      A(15,11) = -1.8913028948478674610382580129D0
      A(15,12) = 1.00148450702247178036685959248D0
      A(15,13) = 4.64119959910905190510518247052D-3
      A(15,14) = 1.12187550221489570339750499063D-2
C
      A(16,1) = -2.75196297205593938206065227039D-1
      A(16,2) = 0.0D0
      A(16,3) = 3.66118887791549201342293285553D-2
      A(16,4) = 9.7895196882315626246509967162D-3
      A(16,5) = -1.2293062345886210304214726509D1
      A(16,6) = 1.42072264539379026942929665966D1
      A(16,7) = 1.58664769067895368322481964272D0
      A(16,8) = 2.45777353275959454390324346975D0
      A(16,9) = -8.93519369440327190552259086374D0
      A(16,10) = 4.37367273161340694839327077512D0
      A(16,11) = -1.83471817654494916304344410264D0
      A(16,12) = 1.15920852890614912078083198373D0
      A(16,13) = -1.72902531653839221518003422953D-2
      A(16,14) = 1.93259779044607666727649875324D-2
      A(16,15) = 5.20444293755499311184926401526D-3
C
      A(17,1) = 1.30763918474040575879994562983D0
      A(17,2) = 0.0D0
      A(17,3) = 1.73641091897458418670879991296D-2
      A(17,4) = -1.8544456454265795024362115588D-2
      A(17,5) = 1.48115220328677268968478356223D1
      A(17,6) = 9.38317630848247090787922177126D0
      A(17,7) = -5.2284261999445422541474024553D0
      A(17,8) = -4.89512805258476508040093482743D1
      A(17,9) = 3.82970960343379225625583875836D1
      A(17,10) = -1.05873813369759797091619037505D1
      A(17,11) = 2.43323043762262763585119618787D0
      A(17,12) = -1.04534060425754442848652456513D0
      A(17,13) = 7.17732095086725945198184857508D-2
      A(17,14) = 2.16221097080827826905505320027D-3
      A(17,15) = 7.00959575960251423699282781988D-3
      A(17,16) = 0.0D0
C
C
      BCAP(1) = 1.21278685171854149768890395495D-2
      BCAP(2) = 0.0D0
      BCAP(3) = 0.0D0
      BCAP(4) = 0.0D0
      BCAP(5) = 0.0D0
      BCAP(6) = 0.0D0
      BCAP(7) = 8.62974625156887444363792274411D-2
      BCAP(8) = 2.52546958118714719432343449316D-1
      BCAP(9) = -1.97418679932682303358307954886D-1
      BCAP(10) = 2.03186919078972590809261561009D-1
      BCAP(11) = -2.07758080777149166121933554691D-2
      BCAP(12) = 1.09678048745020136250111237823D-1
      BCAP(13) = 3.80651325264665057344878719105D-2
      BCAP(14) = 1.16340688043242296440927709215D-2
      BCAP(15) = 4.65802970402487868693615238455D-3
C      BCAP(16) =      0.0D0
C      BCAP(17) =      0.0D0
C
      BDCAP(1) = 1.21278685171854149768890395495D-2
      BDCAP(2) = 0.0D0
      BDCAP(3) = 0.0D0
      BDCAP(4) = 0.0D0
      BDCAP(5) = 0.0D0
      BDCAP(6) = 0.0D0
      BDCAP(7) = 9.08394342270407836172412920433D-2
      BDCAP(8) = 3.15683697648393399290429311645D-1
      BDCAP(9) = -2.63224906576909737811077273181D-1
      BDCAP(10) = 3.04780378618458886213892341513D-1
      BDCAP(11) = -4.15516161554298332243867109382D-2
      BDCAP(12) = 2.46775609676295306562750285101D-1
      BDCAP(13) = 1.52260530105866022937951487642D-1
      BDCAP(14) = 8.14384816302696075086493964505D-2
      BDCAP(15) = 8.50257119389081128008018326881D-2
      BDCAP(16) = -9.15518963007796287314100251351D-3
      BDCAP(17) = 2.5D-2
C
      B(1) = 1.70087019070069917527544646189D-2
      B(2) = 0.0D0
      B(3) = 0.0D0
      B(4) = 0.0D0
      B(5) = 0.0D0
      B(6) = 0.0D0
      B(7) = 7.22593359308314069488600038463D-2
      B(8) = 3.72026177326753045388210502067D-1
      B(9) = -4.01821145009303521439340233863D-1
      B(10) = 3.35455068301351666696584034896D-1
      B(11) = -1.31306501075331808430281840783D-1
      B(12) = 1.89431906616048652722659836455D-1
      B(13) = 2.68408020400290479053691655806D-2
      B(14) = 1.63056656059179238935180933102D-2
      B(15) = 3.79998835669659456166597387323D-3
      B(16) = 0.0D0
C      B(17) =      0.0D0
C
      BD(1) = 1.70087019070069917527544646189D-2
      BD(2) = 0.0D0
      BD(3) = 0.0D0
      BD(4) = 0.0D0
      BD(5) = 0.0D0
      BD(6) = 0.0D0
      BD(7) = 7.60624588745593757356421093119D-2
      BD(8) = 4.65032721658441306735263127583D-1
      BD(9) = -5.35761526679071361919120311817D-1
      BD(10) = 5.03182602452027500044876052344D-1
      BD(11) = -2.62613002150663616860563681567D-1
      BD(12) = 4.26221789886109468625984632024D-1
      BD(13) = 1.07363208160116191621476662322D-1
      BD(14) = 1.14139659241425467254626653171D-1
      BD(15) = 6.93633866500486770090602920091D-2
      BD(16) = 2.0D-2
C      BD(17) =      0.0D0
C
      RETURN
      END
