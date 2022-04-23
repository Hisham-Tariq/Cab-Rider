// import * as functions from "firebase-functions";

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

// Called Automatically when a new trip need a Rider
// it will retrieve the locations of all the riders
// who are currently active(Means App is on)
export const notificationWhenNeedDriver = functions.firestore
    .document('inProcessingTrips/{tripId}')
    .onCreate(async snapshot => {
        const newTrip: FirebaseFirestore.DocumentData = snapshot.data();


        const payload: admin.messaging.MessagingPayload = {
            data: {
                'lat': newTrip.lat,
                'lng': newTrip.lng,
                'vehicle': newTrip.vehicle,
                'id': snapshot.id.toString(),
                'funName': 'notificationWhenNeedDriver',
            },
            // notification: {
            //     title: 'Searching',
            //     body: `A Passenger is searching for a ride`,
            //     icon: '@mipmap/ic_launcher',
            //     click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
            // }
        };

        return fcm.sendToTopic('drivers', payload);
    });


// it will be called to Request the nearest rider
// it takes 4 values from Client Side(User Side)
// ********* Data *********
// 1. userId
// 2. riderId
// 3. tripId
// 4. timeout
// ********* Return *********
// None
// ********* Send(Rider) *********
// 1. userId
// 2. tripId
export const requestTheRiderAboutNewTrip = functions
    .https.onCall(async (data, context) => {
        const riderTokens = await db
            .collection('rider')
            .doc(data['riderId'])
            .collection('tokens')
            .get();

        const tokens = riderTokens.docs.map(snap => snap.id);

        const payload: admin.messaging.MessagingPayload = {
            data: {
                'userId': data['userId'],
                'tripId': data['tripId'],
                'timeout': data['timeout'],
                'funName': 'requestTheRiderAboutNewTrip',
            },
            notification: {
                title: 'Need Rider',
                body: `A Passenger need a rider do you want to accept the rider?`,
                icon: 'your-icon-url',
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        return fcm.sendToDevice(tokens, payload);
    });


// it will be called to send the Rider will response to
// New Trip request
// it takes 3 values from Client Side(Rider Side)
// ********* Data *********
// 1. userId
// 2. riderId
// 3. response(String bool)
// ********* Return *********
// None
// ********* Send(User) *********
// 1. riderId
// 2. response(String bool)
export const notifyTheUserAboutHisTripRiderResponse = functions
    .https.onCall(async (data, context) => {

    const userTokens = await db
        .collection('users')
        .doc(data['userId'])
        .collection('tokens')
        .get();

    const tokens = userTokens.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
        data: {
            'riderId': data['riderId'],
            'response': data['response'],
            'funName': 'notifyTheUserAboutHisTripRiderResponse',
        },
    };
    return fcm.sendToDevice(tokens, payload);
});




// it will be called to Request the client to confirm trip
// has been started
// it takes 1 values from Client Side(Rider Side)
// ********* Data *********
// 1. userId
// 2. docId(Where user will update its response)
// ********* Return *********
// None
// ********* Send(User) *********
// 1. docId(Where user will update its response)
export const confirmUserTripHasStarted = functions
    .https.onCall(async (data, context) => {

    const userTokens = await db
        .collection('users')
        .doc(data['userId'])
        .collection('tokens')
        .get();

    const tokens = userTokens.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
        data: {
            'docId': data['docId'],
            'funName': 'confirmUserTripHasStarted',
        },
        notification: {
                        title: 'Trip Started?',
                        body: `Rider is requesting to confirm that trip has been started`,
                        icon: 'your-icon-url',
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
    };
    return fcm.sendToDevice(tokens, payload);
});

export const confirmUserTripHasEnded = functions
    .https.onCall(async (data, context) => {

    const userTokens = await db
        .collection('users')
        .doc(data['userId'])
        .collection('tokens')
        .get();

    const tokens = userTokens.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
        data: {
            'docId': data['docId'],
            'funName': 'confirmUserTripHasEnded',
        },
        notification: {
                        title: 'Trip Ended?',
                        body: `Rider is requesting to confirm that trip has been ended`,
                        icon: 'your-icon-url',
                        click_action: 'FLUTTER_NOTIFICATION_CLICK'
                    }
    };
    return fcm.sendToDevice(tokens, payload);
});