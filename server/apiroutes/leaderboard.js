const express = require('express');
const router = express.Router();
const { executeQuery } = require('../utils/database.js');
const verifyAuthToken = require('../utils/requireAuth.js');
const admin = require('firebase-admin');

router.route('/*')
    .all((req, res, next) => verifyAuthToken(req, res, next));

router.route('/friends')
    .get((req,res)=> {
        const userID = req.headers.userid

         // Vérification des types
         if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }

        const getLeaderboard = `
                SELECT *
                FROM users
                ORDER BY score DESC ;`;
            const leaderboardResult = executeQuery(getLeaderboard);
        
        if (leaderboardResult.length > 0 ){
            const response = leaderboardResult;
            return res.status(200).json(response);
        } else {
            const response = {
                error : true,
                error_message : 'Internal Server Error',
                error_code : 2
            }
            return res.status(500).json(response)
        }
        
    })


router.route('/world')
    .get((req,res)=> {
        const userID = req.headers.userid

         // Vérification des types
         if (typeof userID !== 'string') {
            const response = {
                    error : true,
                    error_message : 'Invalid user ID',
                    error_code : 1
            }
            return res.status(400).json(response);
        }

        const getFriendsQuery = `
                SELECT userID1, userID2
                FROM friends
                WHERE (userID1 = ? OR userID2 = ?) AND friendshipStatus = '22' ;
            `;
        const friendsResult = executeQuery(getFriendsQuery, [userID, userID]);

        // Extraire les IDs des amis (-:
        const friendIDs = friendsResult.map(friendship => {
            return friendship.userID1 === userID ? friendship.userID2 : friendship.userID1;
        });

        friendIDs.push(userID);

        const getLeaderboard = `
                SELECT *
                FROM users
                WHERE userID IN (?)
                ORDER BY score DESC ;`;
            const leaderboardResult = executeQuery(getLeaderboard, [friendIDs]);
        
        if (leaderboardResult.length > 0 ){
            const response = leaderboardResult;
            return res.status(200).json(response);
        } else {
            const response = {
                error : true,
                error_message : 'Internal Server Error',
                error_code : 2
            }
            return res.status(500).json(response)
        }
        
    })