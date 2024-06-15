
import 'package:palm_api/palm_api.dart';

// Instantiate the client
final palm = TextService(apiKey: 'AIzaSyCztovkGPrClJfKfbDjK9NdjHw6NXSKB-I');

// Generate a message
Future<String> getResponse(String message) async {
  try {
    final response = await palm.generateText(
      model: PalmModel.textBison001.name, // or 'text-bison-001',
      prompt: TextPrompt(text: message),
    );
    response.candidates.forEach(print);

    if (response != null) {
      return response.candidates[0].output;
    }

    return 'Something went wrong';
  } catch (e) {
    return 'Bad response';
  }
}
