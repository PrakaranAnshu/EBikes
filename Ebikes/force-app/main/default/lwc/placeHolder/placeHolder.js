import { LightningElement, api, track } from 'lwc';
import BIKE_ASSETS_URL from '@salesforce/resourceUrl/bike_assets';


export default class PlaceHolder extends LightningElement {
    @api message;
    @track logoUrl = BIKE_ASSETS_URL + '/logo.svg';
}