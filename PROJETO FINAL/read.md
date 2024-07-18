# Final Project

## FP 1: Driving Through the City

In this project you will develop the software layers responsible for the control of an autonomous car. The layers are illustrated in the picture below.
[![VcXS1G.image.png](https://i.im.ge/2024/07/19/VcXS1G.image.png)](https://im.ge/i/image.VcXS1G)

The ACOS layer is responsible for managing the hardware. It must provide a set of services for the CoLib layer through syscalls. The ACOS layer also contains the code that will be executed in machine mode and must be implemented in RISC-V assembly language.

The CoLib is responsible for providing a friendly programming interface for the Control Logic, called Control API. This layer also must be implemented in assembly language, but its code must be executed in user mode.

The CoLo layer is responsible for the logic that controls the car and uses functions defined by the Control API, implemented by CoLib. An initial version of this layer is available in this file. This version should work correctly if all the other layers have been fully and efficiently implemented, but you can also modify it in case it is necessary. It was implemented in C and must be executed in user mode.

## CoLo Layer

The code for the CoLo layer is already implemented in C and uses the routines available in the Control API to send commands to the car. Your main function is to control the car, but it must also use the API to print timestamps of the arrival of the car on the checkpoints.

### Control Logic of the Car

The car must perform a set of 3 routes through the city, being that the route is determined by a linked list that contains the coordinates of the next checkpoint and the action that must be performed when arriving there. The actions can be:

- **GoForward (0):** the car remains in the same direction it was headed.
- **TurnLeft (1):** the car must turn to the left.
- **Turn Right (2):** the car must turn to the right.
- **GoBack (3):** the car must perform a maneuver to head back where it came from.
- **End (4):** no action is performed, and indicates the end of the route.

The `linked_lists.s` file has 3 linked lists with head nodes A_0, B_0 and C_0.

## CoLib Layer

The CoLib layer must implement the routines of the Control API in RISC-V assembly language. The API routines are listed in the header file `control_api.h` and must be implemented in the `colib.s` file. To interact with the hardware, the code must use syscalls, defined in the next section.

## ACOS Layer

The ACOS layer must be implemented in assembly language in the file named `acos.s`, and must provide the syscalls listed in the table below. You must not implement additional syscalls besides the ones in the table.

### Syscalls Description

| Syscall | Parameters | Return Value | Description |
| ------- | ---------- | ------------ | ----------- |
| **Syscall_set_engine_and_steering** | Code: 10 <br> a0: Movement direction <br> a1: Steering wheel angle | 0 if successful and -1 if failed (invalid parameters) | Start the engine to move the car. a0's value can be -1 (go backward), 0 (off) or 1 (go forward). a1's value can range from -127 to +127, where negative values turn the steering wheel to the left and positive values to the right. |
| **Syscall_set_handbrake** | Code: 11 <br> a0: value stating if the hand brakes must be used. | - | a0 must be 1 to use hand brakes. |
| **Syscall_read_sensors** | Code: 12 <br> a0: address of an array with 256 elements that will store the values read by the luminosity sensor. | - | Read values from the luminosity sensor. |
| **Syscall_read_sensor_distance** | Code: 13 | Value obtained on the sensor reading; -1 in case no object has been detected in less than 20 meters. | Read the value from the ultrasonic sensor that detects objects up to 20 meters in front of the car. |
| **Syscall_get_position** | Code: 15 <br> a0: address of the variable that will store the value of x position. <br> a1: address of the variable that will store the value of y position. <br> a2: address of the variable that will store the value of z position. | - | Read the car's approximate position using the GPS device. |
| **Syscall_get_rotation** | Code: 16 <br> a0: address of the variable that will store the value of the Euler angle in x. <br> a1: address of the variable that will store the value of the Euler angle in y. <br> a2: address of the variable that will store the value of the Euler angle in z. | - | Read the global rotation of the car's gyroscope. |
| **Syscall_read_serial** | Code: 17 <br> a0: buffer <br> a1: size | Number of characters read. | Reads up to size bytes from Serial Port. |
| **Syscall_write_serial** | Code: 18 <br> a0: buffer <br> a1: size | - | Writes a buffer to Serial Port. |
| **Syscall_get_systime** | Code: 20 | - | Time since the system has been booted, in milliseconds. |

### Booting the System

When booting the system, ACOS must transfer the execution to the control application in user mode. To do so, ACOS must:

1. Configure the user and system stacks;
2. Change to user mode;
3. Point the execution flow to the main function of the user program.

### Notes and Observations

- We recommend using the Google Chrome browser (it was tested more extensively).
- Check if the frames per second (FPS) shown in the car screen is around 60. If it is much lower than that, your simulator can be too slow and the tests may fail due to timeout.
- The “Enable Operating System” option must be disabled.
- The devices must be added to the simulator in the following order:
  - GPT
  - Self-Driving Car
  - Serial Port
- You can enable the option “Enable debug controls” to get to know the road. To do so, use the arrow keys or WASD to move the car. This option must be disabled when testing/running your code.
- The syscall operation code must be passed by the `a7` register.
- To initialize the user stack, just set the `sp` register with the value `0x07FFFFFC`.
- Allocate the system stack in the `.bss` section.
- You can test your syscalls implementations using the Syscall Assistant - in this case, you must upload only `acos.s`, and the devices must not be added to the simulator.
- You can test your control library implementation using the Control Library Assistant - in this case, you must upload only `acos.s` and `colib.s`. This file shows how the functions are being tested.
- You can test your solution using the links Route A, Route B, and Route C - In this case, you must upload `acos.s`, `colib.s`, `control_api.h`, and `colo.c` files.
