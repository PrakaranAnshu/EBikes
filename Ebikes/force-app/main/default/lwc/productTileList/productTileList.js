import { LightningElement, api, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getProducts from '@salesforce/apex/ProductController.getProducts';
import { registerListener, unregisterAllListener, fireEvent } from 'c/pubsub';


export default class ProductTileList extends LightningElement {
    @track pageNumber = 1;
    @track pageSize;
    @track totalItemCount = 0;
    @track filters = {};
    @wire(CurrentPageReference) pageReference;
    @wire(getProducts, { filters: '$filters', pageNumber: '$pageNumber' }) products;
    //connected call back method for register an pubsub event
    connectedCallback() {
        registerListener('filterChange', this.handleFilterChange, this);
    }

    //handle the onselected event
    handleProductSelected(event) {
        fireEvent(this.pageReference, 'productSelected', event.detail);
    }

    disconnectedCallback() {
        unregisterAllListener(this);

    }

    handleFilterChange(filters) {
        this.filters = { ...filters };
        this.pageNumber = 1;
    }

    handlePreviousPage() {
        this.pageNumber -= this.pageNumber;
    }
    handleNextPage() {
        this.pageNumber += this.pageNumber;
    }


}