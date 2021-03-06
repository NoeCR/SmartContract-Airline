
export class AirlineService {
    constructor(contract){
        this.contract = contract;
    }

    async getFlights(){
        let total = await this.getTotalFlights();
        let flights = [];

        for (var i = 0; i < total; i++) {
           let flight = await this.contract.flights(i);
           flights.push(flight);
        }
        return this.mapFlights(flights);
    }

    async getTotalFlights(){
        return (await this.contract.totalFlights()).toNumber();
    }

    async getRefundableEther(from){
        return await this.contract.getRefundableEther({ from });
    }
    
    async redeemLoyaltyPoints(from){
        return await this.contract.redeemLoyaltyPoints({ from });
    }

    async getCustomerFlights(account){
        let customerTotalFlights = await this.contract.customerTotalFlights(account);
        let flights = [];
        for(var i = 0; i < customerTotalFlights.toNumber(); i++){
            flights.push(await this.contract.customerFlights(account, i));
        }
        return this.mapFlights(flights);
    }

    mapFlights(flights){
        return flights.map(flight => {
            return {
                name: flight[0],
                price: flight[1].toNumber()
            }
        });
    }

    async buyFlight(flightIndex, from, value){
        return this.contract.buyFlight(flightIndex, {from, value});
    }
}