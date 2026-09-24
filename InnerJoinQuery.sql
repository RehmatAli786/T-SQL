SELECT 
	D.ID,
	D.Name,
	D.Price,
	PD.*
FROM POS.Dishes AS D
INNER JOIN POS.DishesPriceDetail AS PD
	ON PD.DishId = D.Id
WHERE D.ID = 7294;
