import csv
import string
import os

directory = os.getcwd()
for filename in os.listdir(directory):
	file = os.path.join(directory, filename)
	# checking if it is a file
	if file.endswith(".csv"):
		with open(file, 'r') as infile, \
			open('post_' + filename, 'w') as outfile:
			
			data = infile.read()
			data = data.replace("[", "")
			data = data.replace("]", "")
			outfile.write(data)
		infile.close()
		outfile.close()
		# input_file=open(file, 'r')
		# output_file = open('post_' + filename, 'w')
		# data = csv.reader(input_file)
		# writer = csv.writer(output_file,escapechar=' ',quoting=csv.QUOTE_NONE)
		# special1 = '['
		# special2 = ']'
		# for line in data:
		# 	line = str(line)
		# 	new_line = str.replace(line,special1,'')
		# 	new_line = str.replace(new_line,special2,'')
		# 	writer.writerow(new_line.split(','))
		# input_file.close()
		# output_file.close()


# for file in files:
#        if file.endswith(".csv"):
#            f=open(file, 'r')
#            #  perform calculation
#            f.close()

# directory = os.path.join("c:\\","path")
# for root,dirs,files in os.walk(directory):
#     for file in files:
#        if file.endswith(".csv"):
#            f=open(file, 'r')
#            #  perform calculation
#            f.close()    

# input_file = open('frequency_data_tracking_2022-4-20_125216.csv', 'r')
# output_file = open('Output.csv', 'w')


# input_file.close()
# output_file.close() 