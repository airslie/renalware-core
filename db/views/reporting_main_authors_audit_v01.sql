select
      extract(year from users.created_at) as year,
      to_char(users.created_at,'Month') as month,
      users.id as user_id,
      users.family_name || ', ' || users.given_name as name,
      count(letters.*) as total_letters
      from users
inner join letter_letters as letters on letters.author_id = users.id
group by 1, 2, 3
order by year desc, month desc, total_letters desc;
