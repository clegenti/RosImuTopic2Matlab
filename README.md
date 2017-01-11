# RosImuTopic2Matlab

This matlab function reads a text file that contains the IMU data. The text file is generated with ROS.

This is an example how to generate such a text file from a ROS bag.
> rostopic echo -b rosbag_data.bag /imu/data > imu_data.txt

### Function usage

The function name is RIT2M.
> [ imuTimeStamp, imuOrientation, imuAngVelocity, imuLimAcc ] = RIT2M( inputPath, outputPath )

##### Input :
- inputPath : string containing the path to the text file
- outputPath (optional) : string containing the path of the file you want to save the variables in. If this argument is not provided, the function won't write the variables into any file

##### Output :
- imuTimeStamp : matrix (nb messages * 1) containing the IMU data timestamp
- imuOrientation : matrix (nb messages * 4) containing the IMU data orientation quaternion x, y, z, w
- imuAngVelocity : matrix (nb messages * 3) containing the IMU data angular velocity x, y, z
- imuLimAcc : matrix (nb messages * 3) containing the IMU data linear acceleration x, y, z

##### Examples
###### Example 1
> [time, ori, aVel, lAcc] = RIT2M ('imu_data.txt')

This will return the different data from the text file


###### Example2 
> [time, ori, aVel, lAcc] = RIT2M ('imu_data.txt', 'imu.mat')

This will return the different data from the text file and create a Matlab binary file 'imu.mat' that will store the same data (same variables names as the function output).
