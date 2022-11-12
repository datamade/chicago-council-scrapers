BEGIN;

DELETE FROM opencivicdata_votecount;

INSERT INTO opencivicdata_votecount
SELECT gen_random_uuid(),
       option,
       count(*),
       vote_event_id
FROM opencivicdata_personvote
GROUP BY vote_event_id,
         option;

END;
