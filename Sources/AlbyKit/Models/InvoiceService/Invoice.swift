//
//  File.swift
//  
//
//  Created by Thomas Rademaker on 11/21/23.
//

import Foundation

// TODO: which properties are optional
public struct Invoice: Codable, Sendable {
    public let amount: Int
    public let boostagram: Boostagram?
    public let comment: String?
    public let createdAt: Date // "2022-07-05T17:02:20.343Z", TODO: date set properly in codable
    public let creationDate: Int // 1657040540, TODO: this is a date but isn't the same format, can we make this work with Codabale
    public let currency: Currency
    public let customRecords: [String : String]
    public let descriptionHash: String?
    public let expiresAt: Date // "2022-07-05T17:17:20.000Z", TODO: more date stuff
    public let expiry: Int
    public let identifier: String
    public let keysendMessage: String?
    public let memo: String
    public let payerName: String
    public let payerPubkey: String?
    public let preimage: String
    public let paymentHash: String
    public let paymentRequest: String
    public let rHashStr: String
    public let settled: Bool?
    public let settledAt: Date // TODO: more date stuff "2022-07-05T17:02:20.000Z",
    public let state: InvoiceState
    public let type: String
    public let value: Int
}

public enum InvoiceState: String, Codable, Sendable {
    case created = "CREATED"
    case settled = "SETTLED"
}

public struct Boostagram: Codable, Sendable {
    public let action: String
    public let appName: String
    public let boostLink: String
    public let episode: String
    public let feedID: Int
    public let itemID: Int
    public let message: String?
    public let name: String
    public let podcast: String
    public let senderId: String
    public let senderName: String
    public let time: String
    public let ts: Int
    public let url: String
    public let valueMsatTotal: Int
}

/*
[
{
        "amount": 3,
        "boostagram": {
            "action": "stream",
            "app_name": "Fountain",
            "boost_link": "https://fountain.fm/episode/xxx",
            "episode": "Your episode",
            "feedID": 123456789,
            "itemID": 123456789,
            "message": null,
            "name": "Podcaster",
            "podcast": "Your podcast",
            "sender_id": "jack",
            "sender_name": "@jack",
            "time": "00:02:07",
            "ts": 127,
            "url": "https://media.rss.com/yourpodcast/feed.xml",
            "value_msat_total": 3000
        },
        "comment": null,
        "created_at": "2022-07-05T17:02:20.343Z",
        "creation_date": 1657040540,
        "currency": "btc",
        "custom_records": {
            "5482373484": "kW5TLmnj718m6+Z+DPW3xfvHa25mLrQyzgW0iKbQ5xM=",
            "696969": "TGx6bGpaS25NQVRKeEM2ejl0MTk=",
            "7629169": "eyJ2YWx1ZV9tc2F0X3RvdGFsIjozMDAwLCJuYW1lIjoiUG9kY2FzdGVyIiwicG9kY2FzdCI6IkFsYnkgcG9kY2FzdCIsImZlZWRJRCI6NDc4MTE5MiwidXJsIjoiaHR0cHM6Ly9tZWRpYS5yc3MuY29tL2ZsaXR6cG9kY2FzdC9mZWVkLnhtbCIsImFjdGlvbiI6InN0cmVhbSIsIm1lc3NhZ2UiOm51bGwsImFwcF9uYW1lIjoiRm91bnRhaW4iLCJzZW5kZXJfaWQiOiJVYkYwckRVeHJHeWpZcWVKUnhwdCIsInNlbmRlcl9uYW1lIjoiQGFkdWluMTgiLCJlcGlzb2RlIjoiVGVzdCBlcGlzb2RlIDEiLCJpdGVtSUQiOjgxNzY5MTEwMDYsInRzIjoxMjcsInRpbWUiOiIwMDowMjowNyIsImJvb3N0X2xpbmsiOiJodHRwczovL2ZvdW50YWluLmZtL2VwaXNvZGUvODE3NjkxMTAwNiJ9"
        },
        "description_hash": null,
        "expires_at": "2022-07-05T17:17:20.000Z",
        "expiry": 900,
        "identifier": "RGoRuWDG1bo9zMwNFFMXrKWA",
        "keysend_message": null,
        "memo": "",
        "payer_name": "@aduin18",
        "payer_pubkey": null,
        "preimage": "a8768f68cdb405d37b4409766333a266959a75bf64380324a6c2271bac6ec6fd",
        "payment_hash": "1c88e39b9247ade85f48a0f8b57ce1b12e9e220a4bc35edf93e98b2f3c1fc08b",
        "payment_request": "",
        "r_hash_str": "1c88e39b9247ade85f48a0f8b57ce1b12e9e220a4bc35edf93e98b2f3c1fc08b",
        "settled": true,
        "settled_at": "2022-07-05T17:02:20.000Z",
        "state": "SETTLED",
        "type": "incoming",
        "value": 3
    }

]
 
 [
 {
         "amount": 300,
         "boostagram": null,
         "comment": null,
         "created_at": "2022-06-21T11:04:07.237Z",
         "creation_date": 1655809370,
         "currency": "btc",
         "custom_records": null,
         "description_hash": null,
         "expires_at": "2022-06-21T11:17:50.000Z",
         "expiry": 900,
         "identifier": "cdyv5AUpMZeEgEAfsJrbTSMc",
         "keysend_message": null,
         "memo": "Feed Chickens @ pollofeed.com",
         "payer_name": null,
         "payer_pubkey": null,
         "payment_hash": "987f8f9fb750873183a34716359c917d961b0b1a816e4b176a63624a89897678",
         "payment_request": "lnbc3u1p3trf2ksp54a202vea0n3cr9u6evh7rqt858e4jzlwzqvjc4q2la0df2n6qntspp5nplcl8ah2zrnrqargutrt8y30ktpkzc6s9hyk9m2vd3y4zvfweuqdp0gejk2epqgd5xjcmtv4h8xgzqypcx7mrvdanx2ety9e3k7mgxqz95cqpjrzjq2j39c6dx9ea09gkx000aumgv4m4ghu444x7pztl8gnpfka5amkazz60ysqq4dcqqvqqqqqqqqqqqvsq9q9qyysgq4me57k6m7xxsf3fhdq86jk6e29hdsl9h4vjqm5y47vp8cgcfwcfsd7f27t6t73sw87g8l09j4kjxz77dl0kht86qwmxqf9l0nrqwkuqp9yex3z",
         "preimage": "a8768f68cdb405d37b4409766333a266959a75bf64380324a6c2271bac6ec6fd",
         "r_hash_str": "987f8f9fb750873183a34716359c917d961b0b1a816e4b176a63624a89897678",
         "settled": true,
         "settled_at": "2022-06-21T11:04:05.000Z",
         "state": "SETTLED",
         "type": "outgoing",
         "value": 300
     },
 ]
*/


// settled invoice
/*
{
      "amount": 3,
      "boostagram": {
          "action": "stream",
          "app_name": "Fountain",
          "boost_link": "https://fountain.fm/episode/xxx",
          "episode": "Your episode",
          "feedID": 123456789,
          "itemID": 123456789,
          "message": null,
          "name": "Podcaster",
          "podcast": "Your podcast",
          "sender_id": "jack",
          "sender_name": "@jack",
          "time": "00:02:07",
          "ts": 127,
          "url": "https://media.rss.com/yourpodcast/feed.xml",
          "value_msat_total": 3000
      },
      "comment": null,
      "created_at": "2022-07-05T17:02:20.343Z",
      "creation_date": 1657040540,
      "currency": "btc",
      "custom_records": {
          "5482373484": "kW5TLmnj718m6+Z+DPW3xfvHa25mLrQyzgW0iKbQ5xM=",
          "696969": "TGx6bGpaS25NQVRKeEM2ejl0MTk=",
          "7629169": "eyJ2YWx1ZV9tc2F0X3RvdGFsIjozMDAwLCJuYW1lIjoiUG9kY2FzdGVyIiwicG9kY2FzdCI6IkFsYnkgcG9kY2FzdCIsImZlZWRJRCI6NDc4MTE5MiwidXJsIjoiaHR0cHM6Ly9tZWRpYS5yc3MuY29tL2ZsaXR6cG9kY2FzdC9mZWVkLnhtbCIsImFjdGlvbiI6InN0cmVhbSIsIm1lc3NhZ2UiOm51bGwsImFwcF9uYW1lIjoiRm91bnRhaW4iLCJzZW5kZXJfaWQiOiJVYkYwckRVeHJHeWpZcWVKUnhwdCIsInNlbmRlcl9uYW1lIjoiQGFkdWluMTgiLCJlcGlzb2RlIjoiVGVzdCBlcGlzb2RlIDEiLCJpdGVtSUQiOjgxNzY5MTEwMDYsInRzIjoxMjcsInRpbWUiOiIwMDowMjowNyIsImJvb3N0X2xpbmsiOiJodHRwczovL2ZvdW50YWluLmZtL2VwaXNvZGUvODE3NjkxMTAwNiJ9"
      },
      "description_hash": null,
      "expires_at": "2022-07-05T17:17:20.000Z",
      "expiry": 900,
      "identifier": "RGoRuWDG1bo9zMwNFFMXrKWA",
      "keysend_message": null,
      "memo": "",
      "payer_name": "@aduin18",
      "payer_pubkey": null,
      "payment_hash": "1c88e39b9247ade85f48a0f8b57ce1b12e9e220a4bc35edf93e98b2f3c1fc08b",
      "payment_request": "",
      "r_hash_str": "1c88e39b9247ade85f48a0f8b57ce1b12e9e220a4bc35edf93e98b2f3c1fc08b",
      "settled": true,
      "settled_at": "2022-07-05T17:02:20.000Z",
      "state": "SETTLED",
      "type": "incoming",
      "value": 3
  }
*/

// unsettled invoice
/*
{
    "amount": 1000,
    "boostagram": null,
    "comment": null,
    "created_at": "2023-11-08T04:58:11.205Z",
    "creation_date": 1699419491,
    "currency": "btc",
    "custom_records": null,
    "description_hash": null,
    "expires_at": "2023-11-09T04:58:11.000Z",
    "expiry": 86400,
    "fiat_currency": "USD",
    "fiat_in_cents": 36,
    "identifier": "6vaChhm17PqoJ5LJQi1THpUC",
    "keysend_message": null,
    "memo": null,
    "payer_name": null,
    "payer_email": null,
    "payer_pubkey": null,
    "payment_hash": "c169e73f4eb85de8bfa345d0b650b6ffb64054ebb57571e3d3a235b6ba616fe0",
    "payment_request": "lnbc10u1pj5k9trpp5c957w06whpw730arghgtv59kl7myq48tk46hrc7n5g6mdwnpdlsqdp8xemxzsmgdpknzd6sw9h55d2vffgkjv25fpc92sccqzzsxqyz5vqsp52aauy758lcg0hkda65kcrffrlsgum97gt6ywu8r0fz6cacwy0x7q9qyyssqyafv2eamugl5e79wrcu7pzllwyq8kcn5fw8l6njjqtzsfthsd6452nwyjxmpmpek8jrt4j6vtm4wq8dkj34wewz0707yvdgqxqsuhyspxmsmld",
    "r_hash_str": "c169e73f4eb85de8bfa345d0b650b6ffb64054ebb57571e3d3a235b6ba616fe0",
    "settled": null,
    "settled_at": null,
    "state": "CREATED",
    "type": "incoming",
    "value": 1000,
    "metadata": null,
    "destination_alias": null,
    "destination_pubkey": null,
    "first_route_hint_pubkey": null,
    "first_route_hint_alias": null,
    "qr_code_png": "https://getalby.com/api/invoices/6vaChhm17PqoJ5LJQi1THpUC.png",
    "qr_code_svg": "https://getalby.com/api/invoices/6vaChhm17PqoJ5LJQi1THpUC.svg"
}
*/
