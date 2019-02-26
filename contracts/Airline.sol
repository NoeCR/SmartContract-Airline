pragma solidity ^0.4.24;

contract Airline {
    // Propietario del contrato
    address public owner;
    // Estructuras que intervendran en el contrato
    struct Customer {
        uint loyaltyPoints;
        uint totalFlights;
    }

    struct Flight {
        string name;
        uint price;
    }

    uint etherPerPoint = 0.5 ether;

    // Array de vuelos para contratar
    Flight[] public flights;
    // Mappings con información relevante de los customers
    mapping(address => Customer) public customers;
    mapping(address => Flight[]) public customerFlights;
    mapping (address => uint) public customerTotalFlights;
    // evento para mostrar información al reservar un vuelo
    event FlightPurchased(address indexed customer, uint price, string flight);
    // Constructor donde establecemos el propietario y vuelos disponibles
    constructor() public {
        owner = msg.sender;
        flights.push(Flight('Tokio', 4 ether));
        flights.push(Flight('Germany', 3 ether));
        flights.push(Flight('Madrid', 3 ether));
    }
    // Permite comprar un vuelo pagando el precio y registrando en los mappings del customer los: loyaltyPoints,totalFlights y customerFlights
    function buyFlight(uint flightIndex) public payable {
        Flight storage flight = flights[flightIndex]; // Devuelve el vuelo que coincida con el indice
        require(msg.value == flight.price); // Comprueba que se pague al llamar al metodo el precio del vuelo

        Customer storage customer = customers[msg.sender]; 
        customer.loyaltyPoints += 5;
        customer.totalFlights += 1;
        customerFlights[msg.sender].push(flight);
        customerTotalFlights[msg.sender] ++;

        FlightPurchased(msg.sender, flight.price, flight.name);
    }
    // Devuelve un entero positivo con la cantidad de vuelos del array flights
    function totalFlights() public view returns(uint){
        return flights.length;
    }
    // Recupera dinero canjeando los loyaltyPoints acumulados 
    function redeemLoyaltyPoints() public {
        Customer storage customer = customers[msg.sender]; // Obtenemos el customer del mapping
        uint etherToRefund = etherPerPoint * customer.loyaltyPoints; // calculamos los ethers que le seran devueltos

        msg.sender.transfer(etherToRefund); // enviamos los ethers a su wallet
        customer.loyaltyPoints = 0; // Establecemos sus puntos a 0
    }

    function getAirlineBalance() public isOwner view returns (uint) {
        address airlineAddress = address(this) ;
        return airlineAddress.balance;
    }
    // Comprueba que sea el propietario del contrato
    modifier isOwner(){
        require(msg.sender == owner);
        _;
    }
    // Devuelve los loyaltyPoints del customer
    function getRefundableEther() public view returns(uint){
        return etherPerPoint * customers[msg.sender].loyaltyPoints;
    }
}