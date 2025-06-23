import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/token_database.dart';

class AllTokens extends StatefulWidget {
  const AllTokens({super.key});

  @override
  State<AllTokens> createState() => _AllTokensState();
}

class _AllTokensState extends State<AllTokens> {
  final TokenDatabase _tokenDatabase = TokenDatabase();
  late Future<List<Map<String, dynamic>>> _tokensFuture;

  @override
  void initState() {
    super.initState();
    _loadTokens();
  }

  void _loadTokens() {
    setState(() {
      _tokensFuture = _tokenDatabase.getAllTokenData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Tokens',
          style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width * 0.045).clamp(
              16.0,
              20.0,
            ),
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTokens,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tokensFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(
                    14.0,
                    18.0,
                  ),
                  color: Colors.red,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No tokens found',
                style: TextStyle(
                  fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(
                    14.0,
                    18.0,
                  ),
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return _buildTokenList(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildTokenList(List<Map<String, dynamic>> tokens) {
    return ListView.builder(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        final tokenData = token['tokenData'] as Map<String, dynamic>;
        final timestamp = DateTime.parse(token['timestamp']);
        final formattedDate =
            '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';

        // Extract relevant token details
        final tokenValue = token['token'] as String;
        final isValid = tokenData['isActive'] == 'Y';
        final tokenId = tokenData['tokenIdn']?.toString() ?? 'N/A';
        final amount = tokenData['paramAd1']?.toString() ?? 'N/A';
        final validDate = tokenData['ValidDate']?.toString() ?? 'N/A';

        return Card(
          elevation: 3,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.width * 0.04,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExpansionTile(
            title: Text(
              'Token: $tokenValue',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(
                  14.0,
                  18.0,
                ),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            subtitle: Text(
              'Scanned: $formattedDate',
              style: TextStyle(
                fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(
                  12.0,
                  16.0,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            leading: CircleAvatar(
              backgroundColor: isValid ? Colors.green : Colors.red,
              child: Icon(
                isValid ? Icons.check : Icons.close,
                color: Colors.white,
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Token ID', tokenId),
                    _buildDetailRow('Status', isValid ? 'Valid' : 'Invalid'),
                    _buildDetailRow('Amount', amount),
                    _buildDetailRow('Valid Until', validDate),
                    _buildDetailRow('Scan Date', formattedDate),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.width * 0.02,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: (MediaQuery.of(context).size.width * 0.25).clamp(
              80.0,
              120.0,
            ),
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(
                  12.0,
                  16.0,
                ),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: (MediaQuery.of(context).size.width * 0.035).clamp(
                  12.0,
                  16.0,
                ),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
