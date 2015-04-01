#!/usr/bin/env python
# coding=utf-8
import sys
import string
import traceback
import argparse
import numpy
import math
import cmath
from scipy.interpolate import InterpolatedUnivariateSpline
from collections import OrderedDict
import jformat

def rhoa(Z,T):
    uo=4.e-7*cmath.pi
    w=2.*cmath.pi/T
    return abs(Z)**2/(w*uo)

if (__name__=="__main__"):
    parser = argparse.ArgumentParser(
        description="make an input data for rebocc from J-format data files.\n")

    parser.add_argument("stations", metavar="stations.dat",
                        help="a text file whose first column is positions [km]"
                        " and second column is J-format data files.")

    parser.add_argument("periods", metavar="periods.dat",
                        help="a file with periods as generated by Jperiods.py.")

    parser.add_argument("--mode", dest="mode", metavar="cmp/mode",
                        default="ZXY/TE",
                        help="specifies component (ZXY,ZYX,TZX,TZY)/mode"
                        " (te,tm or tp) (default=%(default)s)")

    parser.add_argument("--error", dest="error", metavar="EF1/EF2",
                        default="0.30/0.05",
                        help="sets error floor (default=%(default)s)")

    args = parser.parse_args()

    try:
        stations=open(args.stations,'r').read()
        stations=stations.splitlines()

        pos=[]
        TFlist=[]
        for line in stations:
            cols=line.split(None,2)
            pos.append(float(cols[0]))
            Jfile=cols[1]
            TF=jformat.readJformat(Jfile)
            TFlist.append(TF)

        periods=open(args.periods,'r').read()
        periods=periods.splitlines()
        Tstr = {}
        for line in periods:
            cols=line.split()
            for col in cols:
                if(col=="#"):
                    break
                Tstr[col]=cols[0]

        cols=args.mode.split("/")
        comp=cols[0]
        mode=cols[1].lower()

        cols=args.error.split("/")
        EF1=cols[0]
        EF2=cols[1]

        Taux={}
        for T in set(Tstr.values()):
            Taux[float(T)]=T

        Ttag=OrderedDict()
        Tlist=[]
        k = 0
        for T in sorted(Taux.keys()):
            Ttag[Taux[T]]=k
            Tlist.append(T)
            k+=1

        nT=len(Ttag)
        nS=len(TFlist)
        inclusion=numpy.zeros((nT,nS),dtype=numpy.int16)
        rsp1=numpy.zeros((nT,nS))
        ersp1=numpy.zeros((nT,nS))
        rsp2=numpy.zeros((nT,nS))
        ersp2=numpy.zeros((nT,nS))

        for i in range(0,len(TFlist)):
            for j in range(0,len(TFlist[i][comp])):
                found=False
                data=[]
                for T in Tstr.keys():
                    Ttxt = "%.4e" % TFlist[i][comp][j][0]
                    if(Ttxt==T):
                        data=TFlist[i][comp][j]
                        found=True
                        break

                if(found):
                    k=Ttag[Tstr[T]]
                    Tf=data[0]
                    TF=complex(data[1],data[2])
                    e=data[3]
                    if(mode=="tp"):
                        label_rsp1="rel"
                        rsp1[k,i]=TF.real
                        ersp1[k,i]=e
                        label_rsp2="img"
                        rsp2[k,i]=-TF.imag
                        ersp2[k,i]=e
                    else:
                        label_rsp1="applog"
                        rsp1[k,i]=math.log10(rhoa(TF,Tf))
                        ersp1[k,i]=e*2.*math.log10(math.exp(1.))/abs(TF)
                        label_rsp2="phsrad"
                        phase_shift = 0.
                        if (comp == "ZYX"):
                            phase_shift = math.pi
                        rsp2[k,i]=-1*(cmath.phase(TF)+phase_shift)
                        ersp2[k,i]=e/abs(TF)

                    inclusion[k,i]=1

        # interpolation
        for j in range(0,nS):
            x=[]
            xp=[]
            r=[]
            p=[]
            idx=[]
            for i in range(0,nT):
                if(inclusion[i,j]==1):
                    x.append(math.log10(Tlist[i]))
                    r.append(rsp1[i,j])
                    p.append(rsp2[i,j])
                else:
                    idx.append(i)
                    xp.append(math.log10(Tlist[i]))

            x=numpy.array(x)
            xp=numpy.array(xp)
            r=numpy.array(r)
            p=numpy.array(p)
            spl = InterpolatedUnivariateSpline(x,r,k=1)
            rp = spl(xp)
            if (not isinstance(rp, numpy.ndarray)):
                rp=numpy.array([rp])
            spl = InterpolatedUnivariateSpline(x,p,k=1)
            pp = spl(xp)
            if (not isinstance(pp, numpy.ndarray)):
                pp=numpy.array([pp])

            for i in range(0,len(idx)):
                rsp1[idx[i],j]=rp[i]
                rsp2[idx[i],j]=pp[i]

        # write rebooc data
        print "TITLE                   *"
        print "MODE_TYPE               "+mode
        print "NUMBER_OF_RESPONSE       2"
        print "NUMBER_OF_PERIOD%10s" % (nT);
        line=""
        for T in Ttag.keys():
            line+="%12s" % (T)
        print line

        print "NUMBER_OF_STATION%9s" % (nS)
        line=""
        for s in pos:
            line+="%12.4e" % (float(s)*1.e3)
        print line

        print "DATA_RESPONSE_NO_1* "+label_rsp1
        for i in range(0,len(rsp1)):
            line=""
            for j in range(0,len(rsp1[i])):
                line+="%12.4e" % rsp1[i,j]
            print line

        print "ERROR_RESPONSE_NO_1* "+EF1
        for i in range(0,len(ersp2)):
            line=""
            for j in range(0,len(rsp1[i])):
                if(inclusion[i,j]==1):
                    err=ersp1[i,j]
                else:
                    err=10*2.*math.log10(math.exp(1.))
                line+="%12.4e" % (err)
            print line

        print "DATA_RESPONSE_NO_2* "+label_rsp2
        for i in range(0,len(rsp2)):
            line=""
            for j in range(0,len(rsp2[i])):
                line+="%12.4e" % (rsp2[i,j])
            print line

        print "ERROR_RESPONSE_NO_2* "+EF2
        for i in range(0,len(ersp2)):
            line=""
            for j in range(0,len(rsp1[i])):
                if(inclusion[i,j]==1):
                    err=ersp2[i,j]
                else:
                    err=10
                line+="%12.4e" % (err)
            print line

        print "DATA_INCLUSION_NO_1 index"
        for i in range(0,len(inclusion)):
            line=""
            for j in range(0,len(inclusion[i])):
                line+="%d" % (inclusion[i,j])
            print line

        print "DATA_INCLUSION_NO_2 index"
        for i in range(0,len(inclusion)):
            line=""
            for j in range(0,len(inclusion[i])):
                line+="%d" % (inclusion[i,j])
            print line

    except:
        (ErrorType,ErrorValue,ErrorTB)=sys.exc_info()
        traceback.print_exc(ErrorTB)
