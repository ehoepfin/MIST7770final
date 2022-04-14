# MIST7770final

Spotify 200 charts dataset

Problem: using seasonal attributes of each charted song to imply moods using the scales provided, and which season it is popular. This will help artists make a positive decision by releasing their songs when they will be the most popular according to season and implied mood. 

# Cleaning: 
removed ->
*  Index
*  Streams
*  Artist's followers
*  song ID
*  Weeks Charted
*  Any rows that have a null value for any column after "artist"
*  cleaned the second date in "Weeks highest charted" column to make the data easier to work with, and used sbstr() to make the date be only the month
*  trimmed the months with a "0" to easily assign months to seasons
*  Converted month to one of the 4 seasons

# Plan: 
1. look at the week the song was highest charted.
2. Place each song into a season, which will be an additional column.
3. Use multiple linear regression to predict the month that a song should be released in based on its qualities to chart
4. we found that the model is poor when using all of the attributes, so we will focus on genre and month and the top 4 attributes
