SELECT * FROM ubaid_new.film_top_rnk_1;


DELIMITER $$  
CREATE FUNCTION Film_rating ( 
rating enum('G','PG','PG-13','R','NC-17')
)   
RETURNS VARCHAR(20)  
DETERMINISTIC  
BEGIN  
    DECLARE Film_rating VARCHAR(20);  
    IF rating = 'G' THEN  
        SET Film_rating = 'General'  ;
    ELSEIF rating = 'PG' THEN  
        SET Film_rating = 'Parent_Guided';
    ELSEIF rating = 'PG13' THEN  
        SET Film_rating = 'Parent_Guided_13';  
	ELSEIF rating = 'NC-17' THEN  
        SET Film_rating = 'Not_for_below_17';
	ELSEIF rating = 'R' THEN  
        SET Film_rating = 'Adult';
    END IF;  
    -- return the customer occupation  
    RETURN (Film_rating);
END $$  
DELIMITER ;


SELECT 
    *, 
    Film_rating(rating)
FROM
    film_top_rnk_1;




