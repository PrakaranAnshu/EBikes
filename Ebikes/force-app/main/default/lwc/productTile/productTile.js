import { LightningElement, api, track } from 'lwc';


export default class ProductTile extends LightningElement {
    _product;
    @api
    get product() {
        return this._product;
    }

    set product(value) {
        this._product = value;
        this.pictureURL = value.Picture_URL__c;
        this.name = value.name;
        this.msrp = value.MSRP__c;

    }

    @track pictureURL;
    @track name;
    @track msrp;

    handleClick() {
        const selectedEvent = new CustomEvent('selected', { detail: this.product.id });
        this.dispatchEvent(selectedEvent);

    }
}