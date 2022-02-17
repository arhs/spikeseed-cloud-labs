const mocha = require('mocha');
const chai = require('chai');
const should = chai.should();

const handler = require('./handler');

describe("The handler function", () => {
    it("returns a message", () => {
        handler.hello(undefined, undefined, function(error, response){
            let body = JSON.parse(response.body);
            body.message.should.be.equal('Hello world!');
        });
    });
});