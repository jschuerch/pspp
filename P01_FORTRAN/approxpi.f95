program ApproxPi
    implicit none
    ! -----------------------------------------------Declare
    integer*8 i,nofRedPoints, nofIterations
    real x,y,pi
    ! -----------------------------------------------Input
    !print*, "Enter number of iterations for approximation ..."
    !read*, nofIterations
    nofIterations = 10000000
    print*, "Number of iterations: ", nofIterations
    ! -----------------------------------------------Compute
    
    nofRedPoints = 0

    do i=1,nofIterations
        x = rand(0)
        y = rand(0)

        if ((x**2+y**2) < 1) THEN
            nofRedPoints = nofRedPoints + 1
        endif
    enddo

    pi = float(nofRedPoints) / nofIterations * 4

    ! -----------------------------------------------Output
    print*, "The approximation of pi is: "
    print*, pi
end 