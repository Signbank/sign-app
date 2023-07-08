## Use-case Description

Here the [high-level use-cases](#high-level-use-cases) are described here in a fully dressed use-case form. This is done to get a better understanding of the functional requirements of the application.

The fully dressed use cases presume that the user has already installed the system and accessed the home page.

### Search for a sign
Below, you find the use-case *"Search for a sign,"* which consists of two parts: searching for a sign with a word and searching for a sign through the use of hand shapes and location of the hands.

#### Search for a sign with a word

The user wants to translate a word from their language into their chosen sign language.

<table>
<tbody>
  <tr>
    <td><b>Primary actor</b></td>
    <td colspan="2">User</td>
  </tr>
  <tr>
    <td><b>Brief Description</b></td>
    <td colspan="2">The user wants to know how to do a specific word in a sign language. So the user searches for that word and gets a list of videos back depicting how to perform that sign.</td>
  </tr>
  <tr>
    <td><b>Pre conditions</b></td>
    <td colspan="2">The user has access to the system and the system is functional.</td>
  </tr>
  <tr>
    <td><b>Post conditions</b></td>
    <td colspan="2">The user can view a video of the selected sign.</td>
  </tr>
  <tr>
    <td><b>Main Succes Scenario</b></td>
    <td><b>Actor Action</b></td>
    <td><b>System Responsibility</b></td>
  </tr>
  <tr>
    <td></td>
    <td>1. The user selects the search button. </td>
    <td>2. The system shows an input field. </td>
  </tr>
  <tr>
    <td></td>
    <td>3. The user enters their search query in the input field.</td>
    <td>4. The system shows a list with all the signs that match the search query.</td>
  </tr>
  <tr>
    <td></td>
    <td>5. The user selects one of the signs from the list.</td>
    <td>6. The system shows the video of the selected sign.</td>
  </tr>
  <tr>
    <td><b>Alternative Scenario</b></td>
    <td></td>
    <td>4a. The system can't find any signs matching the search query and informs the user.</td>
  </tr>
  <tr>
    <td></td>
    <td>4b. The user stops searching or tries again and then the use case continues at step 1.</td>
    <td></td>
  </tr>
</tbody>
</table>

#### Search for a sign by its properties 

The user wants to know the meaning of a sign.

<table>
<tbody>
  <tr>
    <td><b>Primary actor</b></td>
    <td colspan="2">User</td>
  </tr>
  <tr>
    <td><b>Brief Description</b></td>
    <td colspan="2">The user wants to know the meaning of a sign in their language. The user can search for the sign by giving information of the sign like the location, number of hands, movement direction and hand shape. If all these criteria match a specific sign the user will be redirected to a video page of the selected sign.</td>
  </tr>
  <tr>
    <td><b>Pre conditions</b></td>
    <td colspan="2">The user has access to the system and the system is functional.</td>
  </tr>
  <tr>
    <td><b>Post conditions</b></td>
    <td colspan="2">The user can view a video of the selected sign.</td>
  </tr>
  <tr>
    <td><b>Main Succes Scenario</b></td>
    <td><b>Actor Action</b></td>
    <td><b>System Responsibility</b></td>
  </tr>
  <tr>
    <td></td>
    <td>1. The user navigates to the correct search page.</td>
    <td>2. The system shows multiple options for the location where the sign could take place, such as the head or the stomach.</td>
  </tr>
  <tr>
    <td></td>
    <td>3. The user selects a location.</td>
    <td>4. The system asks how many hands where used for the sign.</td>
  </tr>
  <tr>
    <td></td>
    <td>5. The user gives the amount of hands used.</td>
    <td>6. The system shows different movement directions for the sign.</td>
  </tr>
  <tr>
    <td></td>
    <td>7. The user selects a movement direction that corresponds to the sign.</td>
    <td>8. The system shows multiple hand shapes that could be used in the sign.</td>
  </tr>
  <tr>
    <td></td>
    <td>9. The user selects a hand shape.</td>
    <td>10. The system shows information of the sign that matches the given input.</td>
  </tr>
  <tr>
    <td><b>Alternative Scenario</b></td>
    <td></td>
    <td>4a/6a/8a The system has found a limited number of signs matching the given input and shows a list of these signs instead of asking for more options.</td>
  </tr>
  <tr>
    <td></td>
    <td>4b/6b/8b The user selects a sign from the list.</td>
    <td>4c/6c/8c The system shows information of that sign.</td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td>10a. The can't find any signs matching the given input.</td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td>10b. The system discards the last given input and shows all the now matching signs. If there are no matching sign the system repeats this step.</td>
  </tr>
  <tr>
    <td></td>
    <td>10c. The user selects a sign from the given list. If no signs match the users intent than the user can stop searching or tries again and the use case starts at step 1.</td>
    <td></td>
  </tr>
</tbody>
</table>

### Sign language learning quiz
<table>
<tbody>
  <tr>
    <td><b>Primary actor</b></td>
    <td colspan="2">User</td>
  </tr>
  <tr>
    <td><b>Brief Description</b></td>
    <td colspan="2">
    The user can access a list of signs and select which signs they want to practice.
    The quiz will present a series of questions, each showing a sign, and the user must select the correct meaning from a list of multiple-choice answers.
    After each question, the quiz will provide feedback to the user, indicating whether their answer was correct or incorrect, and will also provide the correct answer if the user answered incorrectly.
    If users make mistakes during the quiz, they have the opportunity to retry those signs once the quiz is finished.
    </td>
  </tr>
  <tr>
    <td><b>Pre conditions</b></td>
    <td colspan="2">The user has access to a list of signs to learn.</td>
  </tr>
  <tr>
    <td><b>Post conditions</b></td>
    <td colspan="2">The user progression of the selected list is saved.</td>
  </tr>
  <tr>
    <td><b>Main Succes Scenario</b></td>
    <td><b>Actor Action</b></td>
    <td><b>System Responsibility</b></td>
  </tr>
  <tr>
    <td></td>
    <td>1. The user navigates to the sign list page.</td>
    <td>2. The system shows with all the list available to the user.</td>
  </tr>
  <tr>
    <td></td>
    <td>3. The user selects a list from which they would like to learn the signs.</td>
    <td>4. The system navigates to the quiz page of the first new sign.</td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td>5. The system shows a video and asks the user to identify the sign in the video.</td>
  </tr>
  <tr>
    <td></td>
    <td>6. The user tries to identify the sign.</td>
    <td></td>
  </tr>
  <tr>
    <td></td>
    <td>7. The user confirms their selection.</td>
    <td>8. The system shows that the selection of the user was correct.</td>
  </tr>
  <tr>
  <tr>
    <td></td>
    <td></td>
    <td>9. The system asks the users if they would like to continue.</td>
  </tr>
  <tr>
    <td></td>
    <td>10. The user confirms that they would like to continue.</td>
    <td>11. The system goes to the next sign in the list. The use case continues at step 5.</td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td>12. The system will indicate to the user that they have completed the list once they have viewed all signs.</td>
  </tr>
  <tr>
    <td><b>Alternative Scenario</b></td>
    <td></td>
    <td>8a. The system shows that the selection of the user is wrong and adds this sign to a list of signs that the user did not get right.</td>
  </tr>
  <tr>
    <td></td>
    <td></td>
    <td>12a. The system navigates to the first sign the user got wrong. The use case continues at step 5 and repeats for all the signs the user got wrong.</td>
  </tr>
</tbody>
</table>
