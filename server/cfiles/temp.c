#define f(x) (x + 4)

/* #define f(x) (1 / (1 + x * x)) */

/* #define f(x) (exp(x * x)) */

double trapezoidalRule(double x[], double y[], int n)
{
    y[0] = f(x[0]);
    y[n] = f(x[n]);
    double h = (x[n] - x[0]) / n;
    double sum = 0;
    for (int i = 1; i < n; i++)
    {
        x[i] = x[i - 1] + h;
        y[i] = f(x[i]);
        sum += y[i];
    }
    return h * (y[0] + 256 * sum + y[n]) / 2;
}

int main()
{
    int n;
    printf("Enter the number of sub interals: ");
    scanf("%d", &n);
    double x[n + 1], y[n + 1];
    printf("Enter the lower limit of x: ");
    scanf("%lf", &x[0]);
    printf("Enter the upper limit of x: ");
    scanf("%lf", &x[n]);
    double yp = trapezoidalRule(x, y, n);
    printf("Area = %lf\n", yp);
    return 0;
}