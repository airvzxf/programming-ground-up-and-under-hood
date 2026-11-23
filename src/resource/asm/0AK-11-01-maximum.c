/*
 * Solution to Chapter 11, "Use the Concepts": the maximum program
 * of Chapter 3 in C. Compile with `gcc -o 0AK-11-01-maximum-c-bin
 * 0AK-11-01-maximum.c`; it returns 222 as the exit status code.
 */
int main(void)
{
    int data_items[] = {3, 67, 34, 222, 45, 22, 11, 125, 0};
    int largest = data_items[0];

    for (int i = 1; data_items[i] != 0; i++) {
        if (data_items[i] > largest) {
            largest = data_items[i];
        }
    }
    return largest;
}
