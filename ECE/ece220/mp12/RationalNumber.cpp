#include "RationalNumber.h"
// this program provides all the functionality for rational a/b numbers, making the class, implementing it and also defining the operations +-*/, this code is written by 
//jacob hutter and will work with a wide array of different types of operator inputs as well as operands.
//to_String converts numerator and denominator to string of type num/denom
string RationalNumber::to_String(void){
	stringstream my_output;
	my_output << numerator << "/" << denominator;
	return my_output.str();
}

//Empty Constructor
		RationalNumber::RationalNumber(){
		NumberType = RATIONAL;
		numerator = 0;
		denominator = 1;
	}
		//Complete Constructor
		RationalNumber::RationalNumber(int numer, int denom){
		NumberType = RATIONAL;
		numerator = numer;
		denominator = denom;
  }
		
		//Setter and getter functions
		void RationalNumber::set_numerator(int numer){
		numerator = numer;
	}
		void RationalNumber::set_denominator(int denom){
			if(denom != 0)
				denominator = denom;
			else
				cout << "denominator cannont be zero" << endl;
  }
		int RationalNumber::get_numerator(void) const{
				return numerator;
	}
		int RationalNumber::get_denominator(void) const{
				return denominator;
	}

		//Class member functions
		void RationalNumber::set_value (int numer, int denom){
			numerator = numer;
		if(denom != 0)
			denominator = denom;
		else
			cout << "denominator cannont be zero" << endl;
	}
		int RationalNumber::gcd(int a, int b){
			if(b==0)
				return a;
			else 
				return gcd(b,a%b);
				
	}
		double RationalNumber::magnitude(){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return num;
	}
		double RationalNumber::decimal_value() const{
		double num = numerator;
		double den = denominator;
		return (num / den);
	}

		//Operation overload for RationalNumber (op) RationalNumber
		RationalNumber RationalNumber::operator + (const RationalNumber& arg){
		int num = (numerator*arg.get_denominator() + denominator*arg.get_numerator());
		int den = (denominator*arg.get_denominator());
		int dividend = gcd(num,den);
		num = num/dividend;
		den = den/dividend;
		return RationalNumber(num,den);
	}
		RationalNumber RationalNumber::operator - (const RationalNumber& arg){
		int num = (numerator*arg.get_denominator() - denominator*arg.get_numerator());
		int den = (denominator*arg.get_denominator());
		int dividend = gcd(num,den);
		num = num/dividend;
		den = den/dividend;
		return RationalNumber(num,den);
	}
		RationalNumber RationalNumber::operator * (const RationalNumber& arg){
		int num = numerator * arg.get_numerator();
		int den = denominator * arg.get_denominator();
		int dividend = gcd(num,den);
		num = num/dividend;
		den = den/dividend;
		return RationalNumber(num,den);
	}
		RationalNumber RationalNumber::operator / (const RationalNumber& arg){	
		int num = numerator * arg.get_denominator();
		int den = denominator * arg.get_numerator();
		int dividend = gcd(num,den);
		num = num/dividend;
		den = den/dividend;
		return RationalNumber(num,den);
	}

		//Operation overload for RationalNumber (op) ComplexNumber
		ComplexNumber RationalNumber::operator + (const ComplexNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return ComplexNumber::ComplexNumber(arg.get_realComponent() + num,arg.get_imagComponent());
	}
		ComplexNumber RationalNumber::operator - (const ComplexNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return ComplexNumber::ComplexNumber(num - arg.get_realComponent(),-arg.get_imagComponent());
	}
		ComplexNumber RationalNumber::operator * (const ComplexNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return ComplexNumber::ComplexNumber(arg.get_realComponent() * num,num * arg.get_imagComponent());
	}
		ComplexNumber RationalNumber::operator / (const ComplexNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		RealNumber one = RealNumber(num);
		return one / arg;
		//return ComplexNumber::ComplexNumber(real,imag);
	}

		//Operation overload for RationalNumber (op) RealNumber
		RealNumber RationalNumber::operator + (const RealNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return RealNumber::RealNumber(num + arg.get_value());
	}
		RealNumber RationalNumber::operator - (const RealNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return RealNumber::RealNumber(num - arg.get_value());
	}
		RealNumber RationalNumber::operator * (const RealNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return RealNumber::RealNumber(num * arg.get_value());
	}
		RealNumber RationalNumber::operator / (const RealNumber& arg){
		double num = numerator;
		double den = denominator;
		num = num/den;
		return RealNumber::RealNumber(num / arg.get_value());
	}

