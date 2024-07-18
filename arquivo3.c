int read(int __fd, const void *__buf, int __n){
    int ret_val;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall write code (63) \n"
    "ecall               # invoke syscall \n"
    "mv %0, a0           # move return value to ret_val\n"
    : "=r"(ret_val)  // Output list
    : "r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return ret_val;
}

void write(int __fd, const void *__buf, int __n)
{
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}

void exit(int code)
{
  __asm__ __volatile__(
    "mv a0, %0           # return code\n"
    "li a7, 93           # syscall exit (64) \n"
    "ecall"
    :   // Output list
    :"r"(code)    // Input list
    : "a0", "a7"
  );
}

void _start()
{
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD  0
#define STDOUT_FD 1

void inverte(char str[], int tamanho) {
    int inicio = 0;
    int fim = tamanho - 1;
    while (inicio < fim) {
        char aux = str[inicio];
        str[inicio] = str[fim];
        str[fim] = aux;
        inicio++;
        fim--;
    }
}

void int_char(unsigned long int valor, char vetor[]){
  char aux[35];
  int i = 0;
  if(valor > 0){
    while(valor != 0) {
      aux[i] =  (valor % 10) + 48;
      valor /= 10;
      i++;
    }
  }
  else if(valor == 0){
    aux[0] = '0';
  }
  else if(valor < 0){
    valor = - valor;
    aux[0] = '-';
    i = 1;
    while(valor != 0) {
      aux[i] =  (valor % 10) + 48;
      valor /= 10;
      i++;
    }
  }
  for (int k = 0; k < i; k++) {
    vetor[k] = aux[i - k - 1];
  }
  vetor[i] = '\0';
}


int tamanho_vetor(char vetor[]){
  int tamanho = 0;
  while (vetor[tamanho] != '\0') {
    tamanho++;
  }
  return tamanho;
}

int convertechar_int(char vetor[]) {
  int resultado = 0;
  int tamanho = tamanho_vetor(vetor);
  for(int k = 0 ; k < tamanho ; k ++){
    if(vetor[k] >= 48 && vetor[k] <= 57){
      int digito = vetor[k] - 48; 
      resultado = resultado * 10 + digito;
    }
  }
  
  if(vetor[0] == '-'){
    return -resultado;
  }
    
  else{
    return resultado;
  }
}


void decimal_para_binario(long long int decimal) {
  int binario[32];
  int i = 0;
  if (decimal == 0) {
    write(STDOUT_FD,"0b0", 3);
  }
    
  else if(decimal < 0){
    decimal = - decimal;
    while (decimal > 0) {
      binario[i] = decimal % 2;
      decimal /= 2;
      i++;
    }
    
    for (int f = i ; f < 32 ; f++){
      binario[f] = 0;
    }
    
    //invertendo os valores
    for (int k = 0 ; k < 32 ; k++){
      if(binario[k] == 0){
        binario[k] = 1;
      }
      else if(binario[k] == 1){
        binario[k] = 0;
      }
    }
    //adicionando 1
    for(int j = 0 ; j < 34 ; j++){
      if(binario[j] == 0){
        binario[j] = 1;
        break;
      }
      else if(binario[j] == 1){
        binario[j] = 0;
      }
    }
    char novo_vetor[35];
    for(int k = 34 ; k >= 0 ; k--){
      novo_vetor[33 - k] = binario[k] + 48;
    }
    //pritando o valor binário
    write(STDOUT_FD,"0b", 2);
    write(STDOUT_FD,novo_vetor, 35);
    
  }
    
  else{
    while (decimal > 0) {
      binario[i] = decimal % 2;
      decimal /= 2;
      i++;
    }  
    char novo_vetor[35];
    for(int k = i - 1 ; k >= 0 ; k--){
      novo_vetor[35 - k] = binario[k] + 48;
    }
    //pritando o valor binário
    write(STDOUT_FD,"0b", 2);
    write(STDOUT_FD,novo_vetor, 36); 
  }
}


void decimal_hexadecimal(int decimal_num) {
  char hexadecimal[32];
  int i = 0;
  char hex_digits[] = "0123456789abcdef";

  if (decimal_num == 0) {
    write(STDOUT_FD,"0",1);
  }

  else if(decimal_num < 0){
    decimal_num = -decimal_num;
    long long int total = 4294967295;
    long long int diferenca = total - decimal_num + 1;
    while (diferenca > 0) {
      hexadecimal[i] = hex_digits[diferenca % 16];
      diferenca /= 16;
      i++;
    }
    inverte(hexadecimal,i);
    write(STDOUT_FD,"0x", 2);
    write(STDOUT_FD,hexadecimal, i);
  }
    
  else if(decimal_num > 0) {
    while (decimal_num > 0) {
      hexadecimal[i] = hex_digits[decimal_num % 16];
      decimal_num /= 16;
      i++;
    }
    inverte(hexadecimal,i);
    write(STDOUT_FD,"0x", 2);
    write(STDOUT_FD,hexadecimal,i); 
  }  
}

long long int convertehexa_decimal(char vetor[]){
  long long int resultado = 0;
  int tamanho = tamanho_vetor(vetor);
  for(int k = 0 ; k < tamanho  ; k++){
    if(vetor[k] >= '0' && vetor[k] <= '9'){
      int digito = vetor[k] - '0'; 
      resultado = resultado * 16 + digito;
    }
    else if(vetor[k]>= 'a' && vetor[k] <= 'f'){
      int digito = vetor[k] - 'a' + 10;
      resultado = resultado * 16 + digito;
    }
  }
  return resultado;
}


long long int swap(char hexadecimal[], int tamanho){
  char vetor[8] , novo_hexa[8];
  int inicio = 8 - tamanho;
  for (int k = 0 ; k < 8 ; k++){
    if(k < inicio){
      vetor[k] = '0'; 
    }
    else if (k >= inicio){
      vetor[k] = hexadecimal[k - inicio];
    }
  }
  for(int i = 0 ; i < 8 ; i++){
    novo_hexa[i] = vetor[i];
  }
  //inicializando a variavel par
  int par = 1;
  for(int j = 0 ; j < 8 ; j++){
    if(par == 1){
      vetor[j] = novo_hexa[6 - j];
      par = 0;
    }
    else {
      vetor[j] = novo_hexa[8 - j];
      par = 1;
    }
  }
  return convertehexa_decimal(vetor);
  
}

int main(){
  char decimal[35];
  int aux = read(STDIN_FD, (void*) decimal,35);
  if(decimal[1] == 'x'){
    char novo_valor[8];
    int t = tamanho_vetor(decimal) - 3;
    for (int g = 0 ; g < t ; g++){
      novo_valor[g] = decimal[g + 2];
    }
    long long int valor = convertehexa_decimal(novo_valor);
    if(valor >= 2147483648){
      valor = - valor;
    }
    decimal_para_binario(valor);
    write(STDOUT_FD,"\n", 1);
    char vetor2[35];
    int_char(valor,vetor2);
    write(STDOUT_FD,vetor2, 35);
    write(STDOUT_FD,"\n", 1);
    write(STDOUT_FD,decimal,aux);
    if(valor >= 2147483648){
      valor = - valor;
    }
    char vetor[36];
    int_char(swap(novo_valor,t),vetor);
    write(STDOUT_FD,vetor,36);
    write(STDOUT_FD,"\n", 1);
  }
    
  else{
    int decimal_num = convertechar_int(decimal);
    decimal_para_binario(decimal_num);
    write(STDOUT_FD,"\n", 1);
    write(STDOUT_FD,decimal, aux);
    decimal_hexadecimal(decimal_num);
    write(STDOUT_FD,"\n", 1);
    //convertendo o char decimal em char hexadecimal
    char hexadecimal[9];
    int h = 0;
    char hex_digits[] = "0123456789abcdef";
    if (decimal_num == 0) {
      write(STDOUT_FD,"0\n",2);
    }
  
    else if(decimal_num < 0){
      decimal_num = -decimal_num;
      long long int total = 4294967295;
      long long int diferenca = total - decimal_num + 1;
      while (diferenca > 0) {
        hexadecimal[h] = hex_digits[diferenca % 16];
        diferenca /= 16;
        h++;
      }
    }
    
    else if(decimal_num > 0) {
      while (decimal_num > 0) {
        hexadecimal[h] = hex_digits[decimal_num % 16];
        decimal_num /= 16;
        h++;
      }
    }
    char invertido[9];
    //invertendo o hexadecinal
    for (int j = h ; j > 0; j--) {
      invertido[h - j] = hexadecimal[j - 1];
    } 
    char vetor[35];
    int_char(swap(invertido,h),vetor);
    write(STDOUT_FD,vetor, 35);
    write(STDOUT_FD,"\n", 1);
  }
  return 0;
}
