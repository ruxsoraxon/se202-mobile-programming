/// SE202 Mobile Programming — Lab 2, Exercise 8.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Vehicle {
  final String brand;
  Vehicle(this.brand);
}

class ElectricCar extends Vehicle {
  final int batteryCapacity;
  ElectricCar(super.brand, this.batteryCapacity);
}

void main() {
  final car = ElectricCar('Tesla', 75);
  print('${car.brand}: ${car.batteryCapacity} kWh');
}
