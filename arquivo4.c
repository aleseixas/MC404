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

void hex_code(int val){
    char hex[11];
    unsigned int uval = (unsigned int) val, aux;
    
    hex[0] = '0';
    hex[1] = 'x';
    hex[10] = '\n';

    for (int i = 9; i > 1; i--){
        aux = uval % 16;
        if (aux >= 10)
            hex[i] = aux - 10 + 'A';
        else
            hex[i] = aux + '0';
        uval = uval / 16;
    }
    write(1, hex, 11);
}


int convertechar_int(char vetor[] , int tamanho) {
  int resultado = 0;
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


int main(){
  char decimal[31];
  char vetor_auxiliar[5];
  int total = read(STDIN_FD, (void*) decimal,31);
  int v = 0;
  for(int k = 0 ; k < 5 ; k++){
    vetor_auxiliar[k] = decimal[k];
  }
  int mask = 0b11111111111111111111111111111000;
  v = v & mask;
  int seq = convertechar_int(vetor_auxiliar,6);
  v = v | seq;
  for(int k = 6 ; k < 11 ; k++){
    vetor_auxiliar[k - 6] = decimal[k];
  }
  mask = 0b11111111111111111111100000000111;
  v = v & mask;
  seq = convertechar_int(vetor_auxiliar,6);
  seq = seq << 3;
  v = v | seq;
  for(int k = 12 ; k < 17 ; k++){
    vetor_auxiliar[k - 12] = decimal[k];
  }
  mask = 0b11111111111111110000011111111111;
  v = v & mask;
  seq = convertechar_int(vetor_auxiliar,6);
  seq = seq << 11;
  v = v | seq;
  for(int k = 18 ; k < 23; k++){
    vetor_auxiliar[k - 18] = decimal[k];
  }
  mask = 0b11111111111000001111111111111111;
  v = v & mask;
  seq = convertechar_int(vetor_auxiliar,6);
  seq = seq << 16;
  v = v | seq;
  for(int k = 24 ; k < 29 ; k++){
    vetor_auxiliar[k - 24] = decimal[k];
  }
  mask = 0b00000000000111111111111111111111;
  v = v & mask;
  seq = convertechar_int(vetor_auxiliar,6);
  seq = seq << 21;
  v = v | seq;
  hex_code(v);
  return 0;
}

