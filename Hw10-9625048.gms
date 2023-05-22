$title CAPM

Sets i securities / 1, 2, 3/
     iter iteration for sensivity analyse /1*500/;

Alias (i,j);

Parameters r(i) mean annual returns on individual securities(%) /  1 14,
                                                                   2 11,
                                                                   3 10 /
           result(iter,*)  results of efficient frontier
           Sresult(iter,*) results of sharpe ratio   ;


scalars m  initial value for risk aversion parameter( 0<= m <= +inf ) /-0.01/
        rf risk free rate(%) /8/
        maxSRatio maximum sharpe ratio with 8% risk free rate
        sd standard deviation(risk) for optimum solution ;

Table Q(i,j) variance-covariance array  (%)

         1       2       3
   1     20      5       2
   2     5       8       3
   3     2       3       18        ;

Variable
   x(i)    fraction of portfolio invested in secuirity i
   Rp      expected mean portfolio return
   var     variance - here standard deviation is a measure for risk (sqrt(var))
   z       objective value      ;

Positive Variable x;

Equation
   cosum        fractions must add to 1.0
   ExpectedR    mean return on portfolio
   expectedvar  variance(risk) on portfolio
   obj          objective function ;


obj ..         z=e=Rp-m*var ;

expectedvar..  sum(i, x(i)*sum(j,Q(i,j)*x(j))) =e= var;

ExpectedR..    sum(i, r(i)*x(i)) =e= Rp;

cosum..        sum(i, x(i)) =e= 1 ;


Model capm / all /;

option limcol = 100 , limrow= 100;
option optca=0 , optcr=0;

     Loop(iter,
         m=m+0.01 ;
         solve capm using nlp maximizing z ;
         result(iter,'Risk')= sqrt(var.l) ;
         result(iter,'Return')= Rp.L ;
         Sresult(iter,'Sharpe R')= (Rp.l-rf)/sqrt(var.l) ;
         );

maxSRatio=smax(iter,Sresult(iter,'Sharpe R')) ;

     loop(iter,
         if(Sresult(iter,'Sharpe R')=maxSRatio,
         m=ord(iter)*0.01 -0.01 ;
         );
      );

solve capm using nlp maximizing z ;

display result , sresult ;
display maxSRatio ;
display 'Best combination = ', x.l ;
display 'Variance of this combination =', var.L ;
        sd = sqrt(var.l);
display 'In other words, risk(standard deviation = ' , sd ;
display 'Expected return of this combination = ', rp.l ;

execute_unload 'capmOutput.gdx';


