#######FORWARD#######
v2 = X - CX
v4 = Y - CY
v1 = sqr(v2)
v3 = sqr(v4)
v0 = sqr(R)
#####################
#######BACKWARD######
v0, R = Csqr_rev(v0,R)
v0, v1, v3 = Cadd_rev(v0,v1,v3)
v1, v0, v3 = Csub_rev(v1,v0,v3)
v3, v0, v1 = Csub_rev(v3,v0,v1)
v1, v2 = Csqr_rev(v1,v2)
v3, v4 = Csqr_rev(v3,v4)
X, v2, CX = Cadd_rev(X,v2,CX)
CX, X, v2 = Csub_rev(CX,X,v2)
Y, v4, CY = Cadd_rev(Y,v4,CY)
CY, Y, v4 = Csub_rev(CY,Y,v4)
#####################
