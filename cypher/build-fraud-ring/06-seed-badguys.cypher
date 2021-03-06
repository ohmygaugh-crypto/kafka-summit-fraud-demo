/* Seed some really bad actors */
MATCH (p:Party)-[:COOKIE]->(c:Cookie),
  (p)-[:ACCOUNT]->(a:Account),
  (p)-[:CREDIT_CARD]->(cc:CreditCard)
WHERE 
  NOT p.fraud_confirmed AND
  NOT p.fraud_followup AND
  p.flag is null

WITH distinct(p) as party 
ORDER BY party.id DESC LIMIT 10
WITH party
SET 
    party.fraud_followup = true,
    party.fraud_confirmed = true,
    party.case_id = apoc.util.md5([party.id]),
    party.flag = 0,
    party.group = $N
RETURN count(party);

