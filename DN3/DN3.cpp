#include <stdio.h>
#include <math.h>
//nimam že definiranega pi-ja
#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif 

// Definicija funkcije arctan
double calcAtan(double x, int N_steps) {
    double result = 0.0;
    for (int n = 0; n < N_steps; n++) {
        double term = pow(-1, n) * pow(x, 2 * n + 1) / (2 * n + 1);
        result += term;
    }
    return result;
}
// Definicija trapezne metode
double trapeznaMetoda(double (*f)(double, int), double a, double b, int n, int N_steps) {
    double delta_x = (b - a) / n; 
    double integral = 0.0;
    integral += f(a, N_steps) + f(b, N_steps);
    for (int i = 1; i < n; i++) {
        double x_i = a + i * delta_x;
        integral += 2 * f(x_i, N_steps);
    }
    integral *= delta_x / 2;
    return integral;
}

// Funkcija za izraèun
double f(double x, int N_steps) {
    return exp(3 * x) * calcAtan(x / 2, N_steps);
}

int main() {
    double a = 0.0;  
    double b = M_PI / 4; 
    int n = 1000;  
    int N_steps = 10;

    double result = trapeznaMetoda(f, a, b, n, N_steps);

    // Izpis 
    printf("vrednost integrala: %.15f\n", result);

    return 0;
}
