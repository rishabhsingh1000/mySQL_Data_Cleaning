-- This is a data cleaning project on worker layoffs around the world since COVID19 compiled in a table named 'layoffs'. 

select * from layoffs;
create table layoffs_staging like layoffs;
insert into layoffs_staging select * from layoffs;
select * from layoffs_staging;

-- 1.Removing Duplicates

with cte as (select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoffs_staging)
select * from cte where row_num>1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoffs_staging2;

insert into layoffs_staging2 select *,row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num from layoffs_staging;
select * from layoffs_staging2;

select * from layoffs_staging2 where row_num>1;

delete from layoffs_staging2 where row_num>1;

 -- 2.Standardizing the data
 --    a.trim
 select company,trim(company) from layoffs_staging2;
 
 update layoffs_staging2 set company=trim(company);
 
 update layoffs_staging2 set location=trim(location);
 
 update layoffs_staging2 set total_laid_off=trim(total_laid_off);
 
 update layoffs_staging2 set percentage_laid_off=trim(percentage_laid_off);

update layoffs_staging2 set `date` =trim(`date`);

update layoffs_staging2 set stage=trim(stage);

update layoffs_staging2 set country=trim(country);

update layoffs_staging2 set funds_raised_millions=trim(funds_raised_millions);

--    b.String errors

select distinct industry from layoffs_staging2 order by 1;

select * from layoffs_staging2 where industry like 'Crypto%';

update layoffs_staging2 set industry='Crypto' where industry like 'Crypto%';

select * from layoffs_staging2 where industry like 'Crypto%';

select distinct country from layoffs_staging2  where country like 'United States%';

update layoffs_staging2 set country='United States' where country like 'United States%';

--    c.Datatype coreection
select `date`,str_to_date(`date`,'%m/%d/%Y') from layoffs_staging2;
update layoffs_staging2 set `date`=str_to_date(`date`,'%m/%d/%Y');
select `date` from layoffs_staging2;
alter table layoffs_staging2 modify `date` date;

-- 3.Null or Blank values

select * from layoffs_staging2;
select * from layoffs_staging2 where (total_laid_off is null or total_laid_off='') and (percentage_laid_off is null or percentage_laid_off='');

select * from layoffs_staging2 where industry is null or industry='';

select * from layoffs_staging2 where industry is null or industry='';

 select * from layoffs_staging2 t1
 join layoffs_staging2 t2
 on
 t1.company=t2.company
 where (t1.industry is null or t1.industry='') and t2.industry is not null;
 
  select t1.industry,t2.industry from layoffs_staging2 t1
 join layoffs_staging2 t2
 on
 t1.company=t2.company
 where (t1.industry is null or t1.industry='') and t2.industry is not null;
 
 update layoffs_staging2 t1
 join layoffs_staging2 t2
 on
 t1.company=t2.company
 set t1.industry=t2.industry
 where (t1.industry is null or t1.industry='') and t2.industry is not null;
 
 update layoffs_staging2 set industry=null where industry='';
 
 select * from layoffs_staging2  where company='Airbnb';
 
 -- 4.Deleting rows and columns
 
 select * from layoffs_staging2 where total_laid_off is null  and percentage_laid_off is null;
 delete from layoffs_staging2 where total_laid_off is null  and percentage_laid_off is null;
 
 select * from layoffs_staging2;
 alter table layoffs_staging2 drop column row_num;

-- The project is done.The table is now clean and ready for exploratory analysis.





















